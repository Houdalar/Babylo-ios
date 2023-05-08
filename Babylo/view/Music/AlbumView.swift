//
//  AlbumView.swift
//  Babylo
//
//  Created by Babylo  on 8/5/2023.
//

import Combine
import SwiftUI
struct SingleAlbumView: View {
    @EnvironmentObject var backendService: MusicViewModel
    var album: Albums
    @State private var cancellables = Set<AnyCancellable>()

    @State private var tracks: [Track] = []

    var body: some View {
        ScrollView {
            ZStack{
            
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: album.cover)!) { image in
                        image
                            .resizable()
                            .blur(radius: 70)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width / 3)
                    .edgesIgnoringSafeArea(.top)
                }
                .frame(height: UIScreen.main.bounds.height / 3)

                VStack {
                    if backendService.albumTracks.isEmpty {
                        Text("There are no tracks yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 15)
                    } else {
                        ForEach(backendService.albumTracks) { track in
                            TrackRow(track: track, isPlaylistSong: false, isFavorite: false, playlistId: album.id)
                                .padding(.top, 15)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .padding(.leading)
                .padding(.trailing, 30)
                .padding(.top,20)
              
            
            }
                
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            backendService.fetchAlbumTracks(albumId: album.id)
        }
        
    }

  
}

