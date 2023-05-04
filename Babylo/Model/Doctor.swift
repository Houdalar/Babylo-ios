//
//  Doctor.swift
//  Babylo
//
//  Created by Babylo  on 4/5/2023.
//

import Foundation
struct Doctor : Codable , Identifiable{
    let id = UUID()
    let doctor : String
    let babyId : String
    let date : String
    let time : String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case doctor
        case babyId
        case date
        case time
    }
}
