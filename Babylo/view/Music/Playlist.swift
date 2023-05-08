import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var backendService: MusicViewModel

    @State private var selectedPlaylistIndex: Int = 0

   

    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    ZStack(alignment: .topLeading) {
                        if selectedPlaylistIndex >= 0, selectedPlaylistIndex < backendService.playlists.count {
                            AsyncImage(url: URL(string: backendService.playlists[selectedPlaylistIndex].cover)!) { image in
                                image
                                    .resizable()
                                    .blur(radius: 70)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: geometry.size.width, height: geometry.size.width / 3)
                            .edgesIgnoringSafeArea(.top)
                            .padding(.top, 200)
                        }
                        VStack {
                            TabView(selection: $selectedPlaylistIndex) {
                                ForEach(Array(backendService.playlists.indices), id: \.self) { index in
                                    PlaylistCoverView(playlist: backendService.playlists[index])
                                        .tag(index)
                                }
                                AddPlaylistCard()
                                    .tag(-1)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 280)
                            .padding(.horizontal)
                            .padding(.top, 30)
                        }
                        .padding(.leading)
                    }
                }
                .frame(height: UIScreen.main.bounds.height)
                .clipped()

                VStack {
                    if selectedPlaylistIndex >= 0, selectedPlaylistIndex < backendService.playlists.count {
                        if backendService.playlists[selectedPlaylistIndex].tracks.isEmpty {
                            Text("There are no tracks yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 15)
                        } else {
                            ForEach(backendService.playlists[selectedPlaylistIndex].tracks) { track in
                                TrackRow(track: track, isPlaylistSong: true, isFavorite: false, playlistId: backendService.playlists[selectedPlaylistIndex].id)
                                    .padding(.top, 15)
                            }
                            .onDelete(perform: deleteTrack)
                        }
                    }
                }

                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .padding(.top, -520)
                .padding(.leading)
                .padding(.trailing, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            backendService.fetchPlaylists()
           
        }
    }
    func deleteTrack(at offsets: IndexSet) {
        let trackIds = offsets.map { backendService.playlists[selectedPlaylistIndex].tracks[$0].id }
        
        for trackId in trackIds {
            backendService.deleteTrackfromPlaylist(trackid: trackId, playlistid: backendService.playlists[selectedPlaylistIndex].id) { error in
                if let error = error {
                    print("Failed to remove track from playlist: \(error.localizedDescription)")
                } else {
                    print("Track removed from playlist successfully!")
                }
            }
        }
        
        backendService.playlists[selectedPlaylistIndex].tracks.remove(atOffsets: offsets)
    }

   
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
            .environmentObject(MusicViewModel())
    }
}



