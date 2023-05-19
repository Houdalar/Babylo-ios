//
//  songItem.swift
//  Babylo
//
//  Created by houda lariani on 14/4/2023.
//

import SwiftUI
import Kingfisher

// track item

struct TrackRow: View {
    let track: Track
    let isPlaylistSong: Bool
    let isFavorite: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingMusicPlayer = false
    let playlistId : String?


    @EnvironmentObject var musicViewModel: MusicViewModel
    

    
    var body: some View {
        HStack {
            HStack {
                        if let url = URL(string: track.cover) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(track.name)
                                .font(.headline)
                            Text(track.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading)
                        Spacer()
                        Text(track.duration)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.trailing)
            
            Menu {
                if isPlaylistSong {
                    Button(action: {
                        
                        musicViewModel.deleteTrackfromPlaylist(trackid: track.id, playlistid: playlistId ?? "", completionHandler: handleDeleteTrackFromPlaylistResult)

                    }) {
                        Text("Remove from Playlist")
                        Image(systemName: "trash")
                    }
                }

                if isFavorite {
                    Button(action: {
                        // Remove song from favorites
                        
                        musicViewModel.removeFavoriteTrack(trackId: track.id, completionHandler: handleRemoveTrackTofavoritResult)
                    }) {
                        Text("Remove from Favorites")
                        Image(systemName: "trash")
                    }
                } else {
                    Button(action: {
                        musicViewModel.addFavoriteTrackById(trackId: track.id, completionHandler: handleAddTrackTofavoritResult)

                    }) {
                        Text("Add to Favorites")
                        Image(systemName: "star")
                    }
                }

                if !isPlaylistSong {
                    Section {
                        Text("Add to Playlist")
                        ForEach(musicViewModel.playlists, id: \.id) { playlist in
                            Button(action: {
                                musicViewModel.addTracktoPlaylist(trackid: track.id, playlistid: playlist.id, completionHandler: handleAddTrackToPlaylistResult)
                                
                            }) {
                                Text(playlist.name)
                            }
                        }
                    }
                }
            } label: {
                VStack(spacing: 2) {
                    Circle().frame(width: 3, height: 3).foregroundColor(Color.gray)
                    Circle().frame(width: 3, height: 3).foregroundColor(Color.gray)
                    Circle().frame(width: 3, height: 3).foregroundColor(Color.gray)
                }
            }
        }
            .onTapGesture {
                        showingMusicPlayer = true
                    }
                    .sheet(isPresented: $showingMusicPlayer) {
                        MusicPlayerView(track: track)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Add to Playlist"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
    }
    func handleAddTrackToPlaylistResult(_ error: Error?) {
        if let error = error {
            alertMessage = "Failed to add track to playlist: \(error.localizedDescription)"
        } else {
            alertMessage = "Track added to playlist successfully!"
        }
        showAlert = true
    }
    
    func handleDeleteTrackFromPlaylistResult(_ error: Error?) {
        if let error = error {
            alertMessage = "Failed to remove track from playlist: \(error.localizedDescription)"
        } else {
            alertMessage = "Track removed from playlist successfully!"
            musicViewModel.removeTrackFromPlaylist(playlistIndex: musicViewModel.playlists.firstIndex { $0.id == playlistId } ?? 1, trackIndex: musicViewModel.playlists.first(where: { $0.id == playlistId })?.tracks.firstIndex { $0.id == track.id } ?? 1)

        }
        showAlert = true
    }
    
    func handleAddTrackTofavoritResult(_ error: Error?) {
        if let error = error {
            alertMessage = "Failed to add track to favorites: \(error.localizedDescription)"
        } else {
            alertMessage = "Track added to favorites successfully!"
        }
        showAlert = true
    }
    
    func handleRemoveTrackTofavoritResult(_ error: Error?) {
        if let error = error {
            alertMessage = "Failed to remove track: \(error.localizedDescription)"
        } else {
            alertMessage = "Track removed successfully!"
            musicViewModel.removeFavoriteTrackFromList(trackId: track.id)
        }
        showAlert = true
    }

}




// new tracks
struct TrackCardView: View {
    var track: Track
    var trendingLabelOpacity: Double
    @State private var showingMusicPlayer = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
            
            VStack {
                ZStack(alignment: .bottomLeading) {
                    KFImage(URL(string: track.cover))
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 250) // Add this line
                        .clipped()
                        .cornerRadius(20)
                    
                    Text(track.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Text("new")
                        .font(.system(size: 16, weight: .bold))
                        .opacity(trendingLabelOpacity)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
                Spacer()
            }
        }
        .onTapGesture {
                    showingMusicPlayer = true
                }
                .sheet(isPresented: $showingMusicPlayer) {
                    MusicPlayerView(track: track)
                }
        
    }
}

// trending
struct SmallTrackCardView: View {
    var track: Track
    @State private var showingMusicPlayer = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                
                KFImage(URL(string: track.cover))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(20)
            }
            .frame(width: 100, height: 100)
            
            Text(track.name)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .padding(.top, 5)

            Text(track.artist)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .onTapGesture {
                    showingMusicPlayer = true
                }
                .sheet(isPresented: $showingMusicPlayer) {
                    MusicPlayerView(track: track)
                }
    }
}

// albums
struct AlbumCardView: View {
    var playlist: Albums
    @State private var showingMusicPlayer = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 30) // RoundedRectangle for rounded edges
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 180, height: 180)

                KFImage(URL(string: playlist.cover))
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Change this to .fill
                    .frame(width: 180, height: 180) // Update the width and height
                    .cornerRadius(20)
                    .clipped() // Add this to clip the image to the corner radius

                Text(playlist.name) // Display the album name as the category label
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.brown.opacity(0.8)) // Use a darker color
                    .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                    .background(Color.white) // Set background color to white
                    .cornerRadius(30)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0)) // Add padding to create spacing
            }
        }
        .onTapGesture {
                    showingMusicPlayer = true
                }
                .sheet(isPresented: $showingMusicPlayer) {
                    SingleAlbumView(album:playlist)
                }
    }
}
