import Foundation

struct APIAuthUser: Decodable {
    let accessToken: String
    let tokenType: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token", tokenType = "token_type"
    }
}

struct APISignUpUser: Decodable {
    let id: Int
    let email: String
    let isActive: Bool
    let isSuperUser: Bool
    let fullName: String

    private enum CodingKeys: String, CodingKey {
        case id, email, isActive = "is_active", isSuperUser = "is_superuser", fullName = "full_name"
    }
}

struct APIPatient: Decodable {
    let id: Int
    let code: String
    let fullName: String
    let gender: Int
    let birthDate: String
    let ownerId: Int
    let image: String

    private enum CodingKeys: String, CodingKey {
        case id, code, fullName = "full_name", gender, birthDate = "birth_date", ownerId = "owner_id", image
    }
}

struct APIHistory: Decodable {
    let id: Int
    let symptom: Int
    let date: String
    let state: Bool
}

struct APICase: Decodable {
    let id: Int
    let diagnostic: Int?
    let startDate: String
    let endDate: String?
    let history: [APIHistory]

    private enum CodingKeys: String, CodingKey {
        case id, diagnostic, startDate = "start_date", endDate = "end_date", history
    }
}

class APIDiagnosis: Decodable {
    let diagnostic: Int
}

class APIStatistics: Decodable {
    let diagnostics: [Int: Int]
    let symptoms: [Int: Int]
}

let HOSTNAME = "http://ec2-204-236-203-240.compute-1.amazonaws.com"

enum APIUrls: String {
    case login = "/api/v1/login/access-token"
    case signup = "/api/v1/users/open"
    case patients = "/api/v1/patients/"
    case predict = "/api/v1/predict/"
}

enum APIHealthAssitant {
    static func login(email: String, password: String, onComplete: @escaping (UserModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.login.rawValue)",
                                         method: APIClient.Method.post,
                                         params: ["username": email, "password": password, "grant_type": "", "scope": "", "client_id": "", "client_secret": ""],
                                         sessionPolicy: APIClient.SessionPolicy.publicDomain,
                                         contentType: "application/x-www-form-urlencoded",
                                         onCompletion: { (result: Result<APIAuthUser, Error>) in
                                             switch result {
                                             case let .success(data):
                                                 let defaults = UserDefaults.standard
                                                 defaults.set(data.accessToken, forKey: "userToken")
                                                 onComplete(UserModel(email: email, token: data.accessToken))
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func signup(email: String, password: String, onComplete: @escaping (UserModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.signup.rawValue)",
                                         method: APIClient.Method.post,
                                         params: ["email": email, "password": password, "full_name": ""],
                                         sessionPolicy: APIClient.SessionPolicy.publicDomain,
                                         onCompletion: { (result: Result<APISignUpUser, Error>) in
                                             switch result {
                                             case .success:
                                                 APIHealthAssitant.login(email: email, password: password, onComplete: onComplete, onFail: onFail)
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func getPatients(onComplete: @escaping ([PatientModel]) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.patients.rawValue)",
                                         method: APIClient.Method.get,
                                         params: [:],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<[APIPatient], Error>) in
                                             switch result {
                                             case let .success(data):
                                                 let dateFormatter = ISO8601DateFormatter()
                                                 var patientsList: [PatientModel] = []
                                                 for ele in data {
                                                     let gender: Gender = ele.gender == 1 ? Gender.male : Gender.female
                                                     patientsList.append(PatientModel(identification: ele.code, patientId: ele.id, fullName: ele.fullName, imageBase64: ele.image, gender: gender, birthDate: dateFormatter.date(from: ele.birthDate)))
                                                 }
                                                 onComplete(patientsList)
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func newPatient(code: String, fullName: String, gender: Gender, birthDate: Date, base64Image: String, onComplete: @escaping (PatientModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.patients.rawValue)",
                                         method: APIClient.Method.post,
                                         params: [
                                             "code": code,
                                             "full_name": fullName,
                                             "gender": gender.rawValue,
                                             "birth_date": birthDate.ISO8601Format(),
                                             "image": base64Image,
                                         ],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APIPatient, Error>) in
                                             switch result {
                                             case let .success(data):
                                                 let dateFormatter = ISO8601DateFormatter()
                                                 let gender: Gender = data.gender == 1 ? Gender.male : Gender.female
                                                 onComplete(PatientModel(identification: data.code, patientId: data.id, fullName: data.fullName, imageBase64: data.image, gender: gender, birthDate: dateFormatter.date(from: data.birthDate)))
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func getCases(patientId: Int, onComplete: @escaping ([CaseModel]) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.patients.rawValue)\(patientId)/cases",
                                         method: APIClient.Method.get,
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<[APICase], Error>) in
                                             switch result {
                                             case let .success(data):
                                                 let dateFormatter = ISO8601DateFormatter()

                                                 var caseList: [CaseModel] = []
                                                 for ele in data {
                                                     let diagnostic = Diagnosis(rawValue: ele.diagnostic ?? 0) ?? Diagnosis.Unknown
                                                     var historyList: [HistoryModel] = []
                                                     for h in ele.history {
                                                         let symptom = Symptom(rawValue: h.symptom)!
                                                         historyList.append(HistoryModel(date: dateFormatter.date(from: h.date)!, symptom: symptom, state: h.state))
                                                     }
                                                     caseList.append(CaseModel(patientId: patientId, caseId: ele.id, startDate: dateFormatter.date(from: ele.startDate)!, endDate: dateFormatter.date(from: ele.endDate ?? "") ?? nil, history: historyList, diagnosis: diagnostic))
                                                 }
                                                 onComplete(caseList)
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func getOrCreateCase(patientId: Int, onComplete: @escaping (CaseModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.patients.rawValue)\(patientId)/cases",
                                         method: APIClient.Method.post,
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APICase, Error>) in
                                             switch result {
                                             case let .success(data):
                                                 let dateFormatter = ISO8601DateFormatter()

                                                 let diagnostic: Diagnosis = .init(rawValue: data.diagnostic ?? 0) ?? Diagnosis.Unknown
                                                 var historyList: [HistoryModel] = []
                                                 for h in data.history {
                                                     let symptom = Symptom(rawValue: h.symptom)!
                                                     historyList.append(HistoryModel(date: dateFormatter.date(from: h.date)!, symptom: symptom, state: h.state))
                                                 }
                                                 onComplete(CaseModel(patientId: patientId, caseId: data.id, startDate: dateFormatter.date(from: data.startDate)!, endDate: dateFormatter.date(from: data.endDate ?? "") ?? nil, history: historyList, diagnosis: diagnostic))
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func addInformation(patientId: Int, caseId: Int, information: HistoryModel, onComplete: @escaping (HistoryModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.patients.rawValue)\(patientId)/cases/\(caseId)/history",
                                         method: APIClient.Method.post,
                                         params: [
                                             "date": information.date.ISO8601Format(),
                                             "symptom": information.symptom.rawValue,
                                             "state": information.state,
                                         ],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APIHistory, Error>) in
                                             switch result {
                                             case let .success(data):
                                                 let dateFormatter = ISO8601DateFormatter()
                                                 let symptom: Symptom = .init(rawValue: data.symptom)!
                                                 onComplete(HistoryModel(date: dateFormatter.date(from: data.date)!, symptom: symptom, state: data.state))
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func closeCase(patientId: Int, caseId: Int, diagnostic: Diagnosis, date: Date, onComplete: @escaping () -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.patients.rawValue)\(patientId)/cases/\(caseId)",
                                         method: APIClient.Method.put,
                                         params: [
                                             "end_date": date.ISO8601Format(),
                                             "diagnostic": diagnostic.rawValue,
                                         ],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APICase, Error>) in
                                             switch result {
                                             case .success:
                                                 onComplete()
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func predictDiagnostic(caseElem: CaseModel, onComplete: @escaping (Diagnosis) -> Void, onFail: @escaping (Error) -> Void) {
        var params: [String: String] = [:]
        caseElem.history.forEach { history in
            params[history.symptom.identificator] = history.state == true ? "Yes" : "No"
        }
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.predict.rawValue)",
                                         method: APIClient.Method.post,
                                         params: ["evidence": params],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APIDiagnosis, Error>) in
                                             switch result {
                                             case let .success(data):
                                                 onComplete(Diagnosis(rawValue: data.diagnostic) ?? Diagnosis.Unknown)
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }

    static func predictStatistics(onComplete: @escaping (APIStatistics) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(HOSTNAME)\(APIUrls.predict.rawValue)statistics",
                                         method: APIClient.Method.get,
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APIStatistics, Error>) in
                                             switch result {
                                             case let .success(data):
                                                 onComplete(data)
                                             case let .failure(error):
                                                 onFail(error)
                                             }
                                         })
    }
}
