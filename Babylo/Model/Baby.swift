//
//  Baby.swift
//  Babylo
//
//  Created by Babylo  on 11/4/2023.
//


import Foundation

struct Baby: Codable, Identifiable {
    let id: String?
    let babyName: String
    let birthday: String?
    let gender: String?
    let babyPic: String?
    let parent:String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case babyName
        case birthday
        case gender
        case babyPic
        case parent
    }
}

