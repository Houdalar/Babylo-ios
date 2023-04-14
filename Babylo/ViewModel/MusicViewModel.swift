//
//  MusicViewModel.swift
//  Babylo
//
//  Created by houda lariani on 14/4/2023.
//
 import SwiftUI
import  Alamofire

class MusicViewModel: ObservableObject {
    @Published var newTracks: [Track] = []
    @Published var trendingTracks: [Track] = []
    @Published var ALbums: [Albums] = []
    @Published var tracks: [Track] = []
    
    private let baseURL = "http://localhost:8080/"

//http://localhost:8080/media/newest
    
    func fetchNewTracks() {
        AF.request(baseURL+"media/newest",method: .get).validate().responseDecodable(of: [Track].self) { response in
                switch response.result {
                case .success(let tracks):
                    DispatchQueue.main.async {
                        self.newTracks = tracks
                    }
                case .failure(let error):
                    print("Error decoding new tracks: \(error)")
                }
            }
        }
    
    func fetchTrendingTracks() {
        AF.request(baseURL+"media/mostListened",method: .get).validate().responseDecodable(of: [Track].self) { response in
                switch response.result {
                case .success(let tracks):
                    DispatchQueue.main.async {
                        self.trendingTracks = tracks
                    }
                case .failure(let error):
                    print("Error decoding new tracks: \(error)")
                }
            }
        }
    
    func fetchAlbums() {
        AF.request(baseURL+"media/getMediaCategory",method: .get).validate().responseDecodable(of: [Albums].self) { response in
                switch response.result {
                case .success(let tracks):
                    DispatchQueue.main.async {
                        self.ALbums = tracks
                        print("Fetched albums: \(self.ALbums)")
                    }
                case .failure(let error):
                    print("Error decoding new tracks: \(error)")
                }
            }
        }

    func fetchTracks() {
        AF.request(baseURL + "media/getTracks", method: .get).validate().responseDecodable(of: [Track].self) { response in
            switch response.result {
            case .success(let tracks):
                DispatchQueue.main.async {
                    self.tracks = tracks
                }
            case .failure(let error):
                print("Error fetching tracks: \(error)")
            }
        }
    }

}