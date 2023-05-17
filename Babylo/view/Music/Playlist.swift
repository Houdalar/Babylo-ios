import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var backendService: MusicViewModel

    @State private var selectedPlaylistIndex: Int = 0
    @State private var showingDeleteAlert = false
    @State private var playlistToDelete: Int? = nil

   

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
                                  ZStack {
                                      TabView(selection: $selectedPlaylistIndex) {
                                          ForEach(Array(backendService.playlists.indices), id: \.self) { index in
                                              PlaylistCoverView(playlist: backendService.playlists[index]) {
                                                  self.playlistToDelete = index
                                                  self.showingDeleteAlert = true
                                              }
                                              .tag(index)
                                          }
                                          AddPlaylistCard()
                                              .tag(backendService.playlists.count)
                                      }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .frame(height: 280)
                                .padding(.horizontal)
                                .padding(.top, 30)

                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            selectedPlaylistIndex = max(selectedPlaylistIndex - 1, 0)
                                        }
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .background(Color.yellow)
                                            .clipShape(Circle())
                                    }
                                    .disabled(selectedPlaylistIndex == 0)

                                    Spacer()

                                    Button(action: {
                                        withAnimation {
                                            selectedPlaylistIndex = min(selectedPlaylistIndex + 1, backendService.playlists.count)
                                        }
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .background(Color.yellow)
                                            .clipShape(Circle())
                                    }
                                    .disabled(selectedPlaylistIndex == backendService.playlists.count)
                                }
                                .padding(.horizontal, 25)
                            }
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
        
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Playlist"),
                  message: Text("Are you sure you want to delete this playlist? This action cannot be undone."),
                  primaryButton: .destructive(Text("Delete")) {
                      if let index = self.playlistToDelete {
                          self.deletePlaylist(at: index)
                      }
                  },
                  secondaryButton: .cancel())
        }

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
    
    private func deletePlaylist(at index: Int) {
            backendService.deletePlaylist(playlistid: backendService.playlists[index].id) { error in
                if let error = error {
                    print("Failed to delete playlist: \(error.localizedDescription)")
                } else {
                    print("Playlist deleted successfully!")
                    backendService.removePlaylist(playlistId: backendService.playlists[index].id)
                }
            }
        }


   
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
            .environmentObject(MusicViewModel())
    }
}



