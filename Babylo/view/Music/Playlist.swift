import SwiftUI

struct PlaylistView: View {

    let playlists: [Playlist] = [

        Playlist(id: "1", name: "the four ducks", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", owner: "1", tracks: [

            "1",

            "2",

            "3",

            "4",

            "5",

            "6"

        ]),

        Playlist(id: "2", name: "mama frog", cover: "http://localhost:8080/media/images/Mamafrog.png", owner: "1", tracks: [

            "1",

            "2",

            "3"

        ]),

        Playlist(id: "3", name: "My Playlist", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", owner: "1", tracks: [

            "1",

            "3"

        ]),Playlist(id: "4", name: "My Playlist", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", owner: "1", tracks: [

           

            "2",

            "3"

        ])

    ]

    let allTracks: [Track] = [

        Track(id: "1", name: "Track 1", artist: "Artist 1", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 1", url: "http://localhost:8080/media/tracks/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

        Track(id: "2", name: "Track 2", artist: "Artist 2", cover: "http://localhost:8080/media/images/Mamafrog.png", category: "Category 2", url: "http://localhost:8080/media/tracks/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

        Track(id: "3", name: "Track 3", artist: "Artist 3", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", category: "Category 3", url: "http://localhost:8080/media/tracks/track3.mp3", listened: 0, date: "2023-01-01",duration: "04:32")

        ,

        Track(id: "3", name: "Track 3", artist: "Artist 3", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", category: "Category 3", url: "http://localhost:8080/media/tracks/track3.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

        Track(id: "4", name: "Track 4", artist: "Artist 3", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", category: "Category 3", url: "http://localhost:8080/media/tracks/track3.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

        Track(id: "5", name: "Track 5", artist: "Artist 3", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", category: "Category 3", url: "http://localhost:8080/media/tracks/track3.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

        Track(id: "6", name: "Track 6", artist: "Artist 3", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", category: "Category 3", url: "http://localhost:8080/media/tracks/track3.mp3", listened: 0, date: "2023-01-01",duration: "04:32")

    ]

    @State private var selectedPlaylistIndex: Int = 0



    private var tracks: [Track] {

        return fetchTracks(trackIDs: playlists[selectedPlaylistIndex].tracks)

    }



    var body: some View {

        ScrollView {

            VStack {

                GeometryReader { geometry in

                    ZStack(alignment: .topLeading) {

                        AsyncImage(url: URL(string: playlists[selectedPlaylistIndex].cover)!) { image in

                            image

                                .resizable()

                                .blur(radius: 70)

                        } placeholder: {

                            ProgressView()

                        }

                        .frame(width: geometry.size.width, height:geometry.size.width / 3)

                        .edgesIgnoringSafeArea(.top)

                        .padding(.top, 200)



                        VStack {

                            TabView(selection: $selectedPlaylistIndex) {

                                ForEach(playlists.indices) { index in

                                    PlaylistCoverView(playlist: playlists[index])

                                        .tag(index)

                                }

                            }

                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                            .frame(height: 280)

                            .padding(.horizontal)

                            .padding(.top, 30)

                        }

                        .padding(.leading)

                    }

                }

                .frame(height: UIScreen.main.bounds.height  )

                .clipped()

                

                // Add a vertical list for tracks

                VStack {

                    ForEach(tracks) { track in

                        TrackRow(track: track, isPlaylistSong: false)

                            .padding(.top, 15)

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

        

    }

    func fetchTracks(trackIDs: [String]) -> [Track] {

        return trackIDs.compactMap { trackID in

            allTracks.first(where: { $0.id == trackID })

        }

    }

    }



struct PlaylistView_Previews: PreviewProvider {

    static var previews: some View {

        PlaylistView()

    }

}

