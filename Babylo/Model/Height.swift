//
//  Height.swift
//  Babylo
//
//  Created by Babylo  on 25/4/2023.
//

import Foundation

struct Height : Codable , Identifiable, Equatable{
    let id = UUID()
    let height : String
    let babyId : String
    let date : String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case height
        case babyId
        case date
    }
}
