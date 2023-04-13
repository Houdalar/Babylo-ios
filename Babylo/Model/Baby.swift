//
//  Baby.swift
//  Babylo
//
//  Created by Babylo  on 11/4/2023.
//

/*struct Baby : Codable{
    var babyName: String?
    var birthday:String?
    var babyPic:String?
    var parent: String?
    var token: String?
    var gender:String?
        
        enum CodingKeys: String, CodingKey {
            case babyName = "babyName"
            case birthday = "birthday"
            case babyPic = "babyPic"
            case parent = "parent"
            case token = "token"
            case gender="gender"
        }
}
*/

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

