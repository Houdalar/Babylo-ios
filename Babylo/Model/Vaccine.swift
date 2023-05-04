//
//  Vaccine.swift
//  Babylo
//
//  Created by Babylo  on 4/5/2023.
//

import Foundation

struct Vaccine : Codable , Identifiable{
    let id = UUID()
    let vaccine : String
    let babyId : String
    let date : String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vaccine
        case babyId
        case date
    }
}
