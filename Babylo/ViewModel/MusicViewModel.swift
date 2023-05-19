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
    @Published var favoriteTracks: [Track] = []
    @Published var playlists: [Playlist] = []
    @Published var allTracks: [Track] = []
    @Published var albumTracks: [Track] = []

    private let baseURL = "http://localhost:8080/"
    
  /*  private let token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MTc1YjE3YmYwZmFmZmY1OGRlOTRjMiIsImlhdCI6MTY4MjUwNTQwNH0.6pdyCwz5R0m8RbINwlep4b368EKLaJ68g-Xt25uoaI0"*/
    

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
    
    func fetchFavoriteTracks() {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
           

            AF.request(baseURL+"user/music/getFavoritesTracks/"+token,method: .get)
            .validate(contentType: ["application/json"])
                .validate()
                .responseDecodable(of: [Track].self) { response in
                    switch response.result {
                    case .success(let tracks):
                        DispatchQueue.main.async {
                            self.favoriteTracks = tracks
                        }
                    case .failure(let error):
                        print("Error fetching favorite tracks: \(error)")
                    }
                }
        }
    
    func fetchPlaylists() {
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }


            AF.request(baseURL+"user/music/getPlaylists/"+token, method: .get )
                .validate(contentType: ["application/json"])
                .validate()
                .responseDecodable(of: [Playlist].self) { response in
                    switch response.result {
                    case .success(let playlists):
                        DispatchQueue.main.async {
                            self.playlists = playlists
                        }
                    case .failure(let error):
                        print("Error fetching playlists: \(error)")
                    }
                }
        }
    
    func fetchAllTracks(id: String) {
            AF.request(baseURL+"user/music/getPlaylistTracks/"+id, method: .get)
                .validate(contentType: ["application/json"])
                .validate()
                .responseDecodable(of: [Track].self) { response in
                    switch response.result {
                    case .success(let tracks):
                        DispatchQueue.main.async {
                            self.allTracks = tracks
                        }
                    case .failure(let error):
                        print("Error fetching all tracks: \(error)")
                    }
                }
        }
    
    func fetchAlbumTracks(albumId: String) {
           AF.request(baseURL + "user/music/getPlaylistTracks/" + albumId, method: .get)
               .validate(contentType: ["application/json"])
               .validate()
               .responseDecodable(of: [Track].self) { response in
                   switch response.result {
                   case .success(let tracks):
                       DispatchQueue.main.async {
                           self.albumTracks = tracks
                       }
                   case .failure(let error):
                       print("Error fetching album tracks: \(error)")
                   }
               }
       }

    
    func addPlaylist(name: String, cover: UIImage, completion: @escaping (Bool) -> Void) {
       

        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        guard let imageData = cover.jpegData(compressionQuality: 0.5) else {
            completion(false)
            return
        }

        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(token.utf8), withName: "token")
            multipartFormData.append(Data(name.utf8), withName: "name")
            multipartFormData.append(imageData, withName: "cover", fileName: "cover.jpg", mimeType: "image/jpeg")
        }, to: baseURL+"user/music/addPlaylist", method: .post, headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], json["message"] as? String == "PlayList added" {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
    
    func deletePlaylist(playlistid: String, completionHandler: @escaping (Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        AF.request(baseURL+"user/music/deletePlayList/\(playlistid)", method: .delete, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func removePlaylist(playlistId: String) {
        if let index = playlists.firstIndex(where: { $0.id == playlistId }) {
            playlists.remove(at: index)
        }
    }

    
    func deleteTrackfromPlaylist(trackid: String, playlistid: String, completionHandler: @escaping (Error?) -> Void) {
        let parameters: [String: Any] = ["trackid": trackid, "playlistid": playlistid]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        AF.request(baseURL+"user/music/deleteTrackfromPlaylist", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func addTracktoPlaylist(trackid: String, playlistid: String, completionHandler: @escaping (Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let parameters: [String: Any] = ["trackid": trackid, "playlistid": playlistid, "token": token]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(baseURL+"user/music/addTrackToPlayList", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
  

    func removeTrackFromPlaylist(playlistIndex: Int, trackIndex: Int) {
        guard playlistIndex >= 0 && playlistIndex < playlists.count else { return }
        
        var updatedPlaylist = playlists[playlistIndex]
        updatedPlaylist.tracks.remove(at: trackIndex)
        playlists[playlistIndex] = updatedPlaylist
    }
    
    func addFavoriteTrackById(trackId: String, completionHandler: @escaping (Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let parameters: [String: Any] = ["token": token, "songId": trackId]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        AF.request(baseURL+"user/music/addFavoritesTrack", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func removeFavoriteTrack(trackId: String, completionHandler: @escaping (Error?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let parameters: [String: Any] = ["token": token, "trackid": trackId]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        AF.request(baseURL+"user/music/removeFavoritesTrack", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func removeFavoriteTrackFromList(trackId: String) {
        if let index = favoriteTracks.firstIndex(where: { $0.id == trackId }) {
            favoriteTracks.remove(at: index)
        }
    }






}
