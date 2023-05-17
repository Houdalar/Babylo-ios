//
//  UpcomingVaccine.swift
//  Babylo
//
//  Created by Babylo  on 5/5/2023.
//

import Foundation

struct UpcomingVaccine: Codable, Identifiable {
    let id = UUID()
    let vaccine: String
    let date: String
    let babyName: String

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vaccine
        case date
        case babyName
    }
}
