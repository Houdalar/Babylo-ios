//
//  favorites.swift
//  Babylo
//
//  Created by houda lariani on 14/4/2023.
//
import SwiftUI

struct Favorites: View {
    @EnvironmentObject var musicViewModel: MusicViewModel

    let currentlyPlayingTrack: Track

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    CurrentlyPlayingView(track: currentlyPlayingTrack)
                        .padding(.top, 10)

                    ForEach(musicViewModel.favoriteTracks, id: \.id) { track in
                        TrackRow(track: track, isPlaylistSong: true)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.top, 10)
                .onAppear {
                    musicViewModel.fetchFavoriteTracks()
                }
            }
            .padding(.bottom, 100)
        }
    }
}



struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Favorites(currentlyPlayingTrack: Track(id: "2", name: "Track 2", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"))
        }
        .environmentObject(MusicViewModel())
    }
}
