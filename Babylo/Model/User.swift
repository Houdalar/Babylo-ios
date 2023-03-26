//
//  User.swift
//  Babylo
//
//  Created by houda lariani on 18/3/2023.
//
struct User: Codable {
    let email: String
    let token: String
    let name : String

    
    private enum CodingKeys: String, CodingKey {
        case email
        case token
        case name
    }
}

