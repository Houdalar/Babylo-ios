import SwiftUI

struct TracksView: View {
    let currentlyPlayingTrack: Track
    @EnvironmentObject var backendService: MusicViewModel

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    CurrentlyPlayingView(track: currentlyPlayingTrack)
                        .padding(.top, 10)

                    ForEach(backendService.tracks, id: \.id) { track in
                        TrackRow(track: track, isPlaylistSong: false , isFavorite: false,playlistId: nil)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.top, 10)
                .onAppear {
                    
                    backendService.fetchTracks()
                }
            }
            .padding(.bottom) // Updated here
        }
    }
}

struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TracksView(
                currentlyPlayingTrack:  Track(id: "7", name: "Track 4", artist: "Artist 2", cover: "", category: "Category 2", url: "", listened: 0, date: "2023-01-01",duration: "04:32")
            )
        }
        .environmentObject(MusicViewModel())
    }
}
