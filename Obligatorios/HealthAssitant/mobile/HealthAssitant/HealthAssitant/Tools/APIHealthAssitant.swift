//
//  APIHealthAssitant.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

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
        case  id = "id", email = "email", isActive = "is_active", isSuperUser = "is_superuser", fullName = "full_name"
    }
}

struct APIPatient : Decodable {
    let id: Int
    let code: String
    let fullName: String
    let gender: Int
    let birthDate: String
    let ownerId: Int
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", code="code", fullName = "full_name", gender = "gender", birthDate = "birth_date", ownerId = "owner_id"
    }
}

struct APIHistory : Decodable {
    let id: Int
    let symptom: Int
    let date: String
}

struct APICase : Decodable {
    let id: Int
    let diagnostic: Int?
    let startDate: String
    let endDate: String?
    let history: [APIHistory]
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", diagnostic="diagnostic", startDate = "start_date", endDate = "end_date", history = "history"
    }
}

enum APIUrls : String {
    case login = "http://localhost/api/v1/login/access-token"
    case signup = "http://localhost/api/v1/users/open"
    case patients = "http://localhost/api/v1/patients/"
}


class APIHealthAssitant {
    static func login(email:String, password:String, onComplete : @escaping (UserModel) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.login.rawValue,
                                    method: APIClient.Method.post,
                                         params: ["username": email,"password": password,"grant_type":"","scope":"","client_id":"","client_secret":""],
                                    sessionPolicy: APIClient.SessionPolicy.publicDomain,
                                    contentType: "application/x-www-form-urlencoded",
                                    onCompletion: { (result: Result<APIAuthUser, Error>) in
           switch result {
           case .success(let data):
               let defaults = UserDefaults.standard
               defaults.set(data.accessToken, forKey: "userToken")
               onComplete(UserModel(email: email, token: data.accessToken))
           case .failure(let error):
               onFail(error)
           }
       })
    }
    
    static func signup(email:String, password:String, onComplete : @escaping (UserModel) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.signup.rawValue,
                                    method: APIClient.Method.post,
                                         params: ["email": email,"password": password,"full_name":""],
                                    sessionPolicy: APIClient.SessionPolicy.publicDomain,
                                    onCompletion: { (result: Result<APISignUpUser, Error>) in
           switch result {
           case .success(_):
               APIHealthAssitant.login(email: email, password: password, onComplete: onComplete, onFail: onFail)
           case .failure(let error):
               onFail(error)
           }
       })
    }
    
    static func getPatients(onComplete : @escaping ([PatientModel]) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.patients.rawValue,
                                         method: APIClient.Method.get,
                                         params: [:],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<[APIPatient], Error>) in
            switch result {
            case .success(let data):
                let dateFormatter = ISO8601DateFormatter()
                var patientsList : [PatientModel] = []
                for ele in data {
                    let gender : Gender = ele.gender == 1 ? Gender.male : Gender.female
                    patientsList.append(PatientModel(identification: ele.code, patientId:ele.id, fullName: ele.fullName, gender: gender, birthDate: dateFormatter.date(from:ele.birthDate)))
                }
                onComplete(patientsList)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func newPatient(code: String, fullName:String, gender:Gender, birthDate: Date, onComplete : @escaping (PatientModel) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.patients.rawValue,
                                     method: APIClient.Method.post,
                                     params: [
                                        "code":code,
                                        "full_name": fullName,
                                        "gender": gender.rawValue,
                                        "birth_date":birthDate.ISO8601Format()
                                     ],
                                    sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                    onCompletion: { (result: Result<APIPatient, Error>) in
           switch result {
           case .success(let data):
               let dateFormatter = ISO8601DateFormatter()
               let gender : Gender = data.gender == 1 ? Gender.male : Gender.female
               onComplete(PatientModel(identification: data.code, patientId:data.id, fullName: data.fullName, gender: gender, birthDate: dateFormatter.date(from:data.birthDate)))
           case .failure(let error):
               onFail(error)
           }
       })
    }
    
    static func getCases(patientId: Int, onComplete : @escaping ([CaseModel]) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(APIUrls.patients.rawValue)\(patientId)/cases",
                                    method: APIClient.Method.get,
                                    sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                    onCompletion: { (result: Result<[APICase], Error>) in
           switch result {
           case .success(let data):
               let dateFormatter = ISO8601DateFormatter()
               
               var caseList : [CaseModel] = []
               for ele in data {
                   let diagnostic : Diagnosis = Diagnosis(rawValue: ele.diagnostic ?? 0) ?? Diagnosis.Unknown
                   var historyList : [HistoryModel] = []
                   for h in ele.history {
                       let symptom : Symptom = Symptom(rawValue: h.symptom)!
                       historyList.append(HistoryModel(date: dateFormatter.date(from: h.date)!, symptom: symptom))
                   }
                   caseList.append(CaseModel(patientId:patientId, caseId: ele.id, startDate: dateFormatter.date(from: ele.startDate)!, endDate: dateFormatter.date(from: ele.endDate ?? "") ?? nil, history: historyList, diagnosis: diagnostic))
               }
               onComplete(caseList)
           case .failure(let error):
               print(error)
               onFail(error)
           }
       })
    }
    
    static func getOrCreateCase(patientId: Int, onComplete : @escaping (CaseModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(APIUrls.patients.rawValue)\(patientId)/cases",
                                    method: APIClient.Method.post,
                                    sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                    onCompletion: { (result: Result<APICase, Error>) in
           switch result {
           case .success(let data):
               let dateFormatter = ISO8601DateFormatter()
               
               let diagnostic : Diagnosis = Diagnosis(rawValue: data.diagnostic ?? 0) ?? Diagnosis.Unknown
               var historyList : [HistoryModel] = []
               for h in data.history {
                   let symptom : Symptom = Symptom(rawValue: h.symptom)!
                   historyList.append(HistoryModel(date: dateFormatter.date(from: h.date)!, symptom: symptom))
               }
               onComplete(CaseModel(patientId:patientId, caseId: data.id, startDate: dateFormatter.date(from: data.startDate)!, endDate: dateFormatter.date(from: data.endDate ?? "") ?? nil, history: historyList, diagnosis: diagnostic))
           case .failure(let error):
               print(error)
               onFail(error)
           }
       })
    }
    
    static func addInformation(patientId: Int, caseId: Int, information: HistoryModel, onComplete : @escaping (HistoryModel) -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(APIUrls.patients.rawValue)\(patientId)/cases/\(caseId)/history",
                                         method: APIClient.Method.post,
                                         params:[
                                            "date":information.date.ISO8601Format(),
                                            "symptom":information.symptom.rawValue
                                         ],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APIHistory, Error>) in
           switch result {
           case .success(let data):
               let dateFormatter = ISO8601DateFormatter()
               let symptom : Symptom = Symptom(rawValue: data.symptom)!
               onComplete(HistoryModel(date: dateFormatter.date(from: data.date)!, symptom: symptom))
           case .failure(let error):
               print(error)
               onFail(error)
           }
       })
    }
    
    
    static func closeCase(patientId: Int, caseId: Int, diagnostic: Diagnosis, date: Date, onComplete : @escaping () -> Void, onFail: @escaping (Error) -> Void) {
        _ = APIClient.shared.requestItem(urlString: "\(APIUrls.patients.rawValue)\(patientId)/cases/\(caseId)",
                                         method: APIClient.Method.put,
                                         params:[
                                            "end_date":date.ISO8601Format(),
                                            "diagnostic":diagnostic.rawValue
                                         ],
                                         sessionPolicy: APIClient.SessionPolicy.privateDomain,
                                         onCompletion: { (result: Result<APICase, Error>) in
           switch result {
           case .success(_):
               onComplete()
           case .failure(let error):
               print(error)
               onFail(error)
           }
       })
    }
    
    static func predictDiagnostic(caseId: Int, onComplete : @escaping (Diagnosis) -> Void, onFail: @escaping (Error) -> Void){
//        if CaseModel.cases.count < caseId {
//            CaseModel.cases[caseId].count < caseId {
//                onComplete(Diagnosis.allCases.randomElement()!)
//        }
        onFail(NSError(domain:"", code:404))
    }
}
