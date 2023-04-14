//
//  MusicModels.swift
//  Babylo
//
//  Created by houda lariani on 12/4/2023.
//
import SwiftUI

class Library: ObservableObject {
    @Published var tracks: [Track]
    
    init(tracks: [Track]) {
        self.tracks = tracks
    }
}

struct Track: Identifiable, Codable {
    var id: String
    var name: String
    var artist: String
    var cover: String
    var category: String
    var url: String
    var listened: Int
    var date: String
    let duration: String


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case artist
        case cover
        case category
        case url
        case listened
        case date
        case duration
    }
}
struct Playlist: Codable, Identifiable {
    let id: String
    let name: String
    let cover: String
    let owner: String
    let tracks: [String]
}

struct Albums: Identifiable, Codable {
    let id: String
    let name: String
    let cover: String
    let tracks: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case cover
        case tracks
        
    }
}
