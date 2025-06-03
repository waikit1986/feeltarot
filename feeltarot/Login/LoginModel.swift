//
//  LoginModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import Foundation

struct TokenResponse: Decodable {
    let access_token: String
    let token_type: String
    let user_id: String
    let username: String
    let email: String
}

struct CreateUser: Codable {
    let username: String
    let email: String
    let password: String
}

struct UserDisplay: Codable {
    let username: String
    let email: String
}

struct ServerError: Decodable {
    let detail: String
}
