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
}


enum APIUrls : String {
    case signup = "https://api.penca.inhouse.decemberlabs.com/api/v1/user/"
    case login = "https://api.penca.inhouse.decemberlabs.com/api/v1/user/login"
    case predictMatch = "https://api.penca.inhouse.decemberlabs.com/api/v1/match/:matchId"
    case getMatches = "https://api.penca.inhouse.decemberlabs.com/api/v1/match/"
    case getMatchDetails = "https://api.penca.inhouse.decemberlabs.com/api/v1/match/"
    case getBanners = "https://api.penca.inhouse.decemberlabs.com/api/v1/files/"
}

class APIPenca {
    static var currentUser: AuthUser? = nil
    
    static func login(email:String, password:String, onComplete : @escaping (AuthUser) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.login.rawValue,
                                         method: .post,
                                         params: ["email": email,"password": password],
                                         sessionPolicy: .publicDomain,
                                         onCompletion: { (result: Result<AuthUser, Error>) in
            switch result {
            case .success(let data):
                APIPenca.currentUser = data
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
                APIPenca.currentUser = data
                onComplete(data)
            case .failure(let error):
                onFail(error)
            }
        })
    }
    
    static func getMatches(onComplete : @escaping (GetMatches) -> Void, onFail: @escaping (Error) -> Void){
        _ = APIClient.shared.requestItem(urlString: APIUrls.getMatches.rawValue,
                                         method: .get,
                                         params: [:],
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
}
