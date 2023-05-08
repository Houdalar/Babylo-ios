//
//  AudioBook.swift
//  Babylo
//
//  Created by houda lariani on 5/5/2023.
//

import SwiftUI

struct AudioBook: Identifiable, Codable {
    let id : String
    let bookTitle: String
    let author: String
    let cover: String
    let category: String
    let description: String
    let rating: Double
    let url: String
    let listened: Int
    let date: String
    let duration: String
    let narrator: String
    let language: String

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case bookTitle
        case author = "Author"
        case cover
        case category
        case description = "Description"
        case rating = "Rating"
        case url
        case listened
        case date
        case duration
        case narrator
        case language
    }
}
