//
//  User.swift
//  Babylo
//
//  Created by houda lariani on 18/3/2023.
//
struct User: Codable {
    let id: String
    let email: String
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case token
    }
}

