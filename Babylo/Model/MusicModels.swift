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
    let id : String?
    let name: String
    let artist: String
    let cover: String
    let category: String
    let url: String
    var listened: Int
    let date: String
}

struct Playlist: Codable, Identifiable {
    let id: String
    let name: String
    let cover: String
    let owner: String
    let tracks: [String]
}
