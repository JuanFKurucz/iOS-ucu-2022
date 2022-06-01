//
//  APIPenca.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 19/5/22.
//

import Foundation


struct AuthUser: Decodable {
    let userId: Int
    let email: String
    let token: String
}

struct GetMatches: Decodable {
    let matches: [APIMatch]
    let pagination: APIPagination
}

struct APIPagination: Decodable {
    let page: Int
    let totalElements: Int
    let totalPages: Int
    let pageSize: Int
    let hasMorePages: Bool
}

struct APIMatch: Decodable {
    let matchId: Int
    let date: String
    let homeTeamId: Int
    let homeTeamName: String
    let homeTeamLogo: String
    let awayTeamId: Int
    let awayTeamName: String
    let awayTeamLogo: String
    let status: String
    let homeTeamGoals: Int?
    let awayTeamGoals: Int?
    let predictedHomeGoals: Int?
    let predictedAwayGoals: Int?
    let incidences: [MatchLog]?
}

struct APIMatchDetails: Decodable {
    let matchId: Int
    let incidences: [MatchLog]?
}

struct APIPredictMatch: Decodable {
    let userId: Int
    let matchId: Int
    let homeGoals: Int
    let awayGoals: Int
}

struct APIBanners: Decodable {
    let bannerURLs: [String]
}

enum APIUrls : String {
    case signup = "https://api.penca.inhouse.decemberlabs.com/api/v1/user/"
    case login = "https://api.penca.inhouse.decemberlabs.com/api/v1/user/login"
    case match = "https://api.penca.inhouse.decemberlabs.com/api/v1/match/"
    case files = "https://api.penca.inhouse.decemberlabs.com/api/v1/files/"
}

class APIPenca {
    static func login(email:String, password:String, onComplete : @escaping (AuthUser) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.login.rawValue,
                                         method: .post,
                                         params: ["email": email,"password": password],
                                         sessionPolicy: .publicDomain,
                                         onCompletion: { (result: Result<AuthUser, Error>) in
            switch result {
            case .success(let data):
                let defaults = UserDefaults.standard
                defaults.set(data.token, forKey: "userToken")
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func signup(email:String, password:String, onComplete : @escaping (AuthUser) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.signup.rawValue,
                                         method: .post,
                                         params: ["email": email,"password": password],
                                         sessionPolicy: .publicDomain,
                                         onCompletion: { (result: Result<AuthUser, Error>) in
            switch result {
            case .success(let data):
                let defaults = UserDefaults.standard
                defaults.set(data.token, forKey: "userToken")
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func getMatches(onComplete : @escaping (GetMatches) -> Void, onFail: @escaping (Error) -> Void, teamName: String? = nil, status: String? = nil){
        var params: [String:Any] = [:]
        if teamName != nil{
            params["teamName"] = teamName
        }
        if status != nil{
            params["status"] = status
        }
        _ = APIClient.shared.requestItem(urlString: APIUrls.match.rawValue,
                                         method: .get,
                                         params: params,
                                         sessionPolicy: .privateDomain,
                                         onCompletion: { (result: Result<GetMatches, Error>) in
            switch result {
            case .success(let data):
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func getMatchDetails(matchId: Int, onComplete : @escaping (APIMatchDetails) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: "\(APIUrls.match.rawValue)\(matchId)",
                                         method: .get,
                                         params: [:],
                                         sessionPolicy: .privateDomain,
                                         onCompletion: { (result: Result<APIMatchDetails, Error>) in
            switch result {
            case .success(let data):
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func predictMatch(matchId: Int, homeGoals: Int, awayGoals: Int, onComplete : @escaping (APIPredictMatch) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: "\(APIUrls.match.rawValue)\(matchId)",
                                         method: .patch,
                                         params: ["homeGoals":homeGoals,"awayGoals":awayGoals],
                                         sessionPolicy: .privateDomain,
                                         onCompletion: { (result: Result<APIPredictMatch, Error>) in
            switch result {
            case .success(let data):
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func getBannerURLs(onComplete : @escaping (APIBanners) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.files.rawValue,
                                         method: .get,
                                         params: [:],
                                         sessionPolicy: .privateDomain,
                                         onCompletion: { (result: Result<APIBanners, Error>) in
            switch result {
            case .success(let data):
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
}
