//
//  Weight.swift
//  Babylo
//
//  Created by Babylo  on 26/4/2023.
//

import Foundation

struct Weight : Codable , Identifiable{
    let id = UUID()
    let weight : String
    let babyId : String
    let date : String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case weight
        case babyId
        case date
    }
}

