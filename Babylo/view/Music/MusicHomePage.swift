import SwiftUI



enum Tab : CaseIterable {

    case overview, tracks, playlists, favorites

}



struct MusicPlayerHomeView: View {

    @State private var selectedTab: Tab = .overview



       var body: some View {

           VStack (alignment: .leading){

               Text("Music")

                   .foregroundColor(Color.gray)

                   .padding(.horizontal, 20)

                   .font(Font.system(size: 25))

                   .padding(.top,20)

               

               HStack(spacing: 10) {

                   ForEach(Tab.allCases, id: \.self) { tab in

                       Button(action: {

                           selectedTab = tab

                       }) {

                           Text(tab.title)

                               .font(.system(size: 14))

                               .fontWeight(selectedTab == tab ? .bold : .regular)

                               .padding(.vertical, 8)

                               .padding(.horizontal, 10)

                               .background(

                                   RoundedRectangle(cornerRadius: 30)

                                       .fill(selectedTab == tab ? Color.yellow : Color.white)

                               )

                               .foregroundColor(selectedTab == tab ? Color.white : Color.gray)

                       }

                   }

               }

               .padding(.top)

               .padding(.horizontal)



               switch selectedTab {

               case .overview:

                   NavigationView {

                       OverviewView()

                   }

               case .tracks:

                   NavigationView {

                       TracksView(currentlyPlayingTrack: Track(id: "2", name: "Track 2", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"))



                   }

               case .playlists:

                   NavigationView {

                       PlaylistView()

                   }

               case .favorites:

                   NavigationView {

                     //  FavoritesView()

                       Favorites(tracks: [

                        Track(id: "1", name: "Track 1", artist: "Artist 1", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 1", url: "http://localhost:8080/media/tracks/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                                           Track(id: "2", name: "Track 2", artist: "Artist 2", cover: "http://localhost:8080/media/images/EducationIsTheWayUp.png", category: "Category 2", url: "http://localhost:8080/media/tracks/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                                           Track(id: "3", name: "Track 3", artist: "Artist 1", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 1", url: "https://example.com/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                                           Track(id: "4", name: "Track 4", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                                           Track(id: "5", name: "Track 5", artist: "Artist 1", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 1", url: "https://example.com/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                                           Track(id: "6", name: "Track 6", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                        Track(id: "7", name: "Track 4", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                        Track(id: "88", name: "Track 5", artist: "Artist 1", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 1", url: "https://example.com/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                       

                        Track(id: "10", name: "Track 4", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                        Track(id: "11", name: "Track 5", artist: "Artist 1", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 1", url: "https://example.com/track1.mp3", listened: 0, date: "2023-01-01",duration: "04:32"),

                        Track(id: "12", name: "Track 6", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32")

                                          ], currentlyPlayingTrack: Track(id: "2", name: "Track 2", artist: "Artist 2", cover: "http://localhost:8080/media/images/Duck.png1681338914683.png", category: "Category 2", url: "https://example.com/track2.mp3", listened: 0, date: "2023-01-01",duration: "04:32"))

                   }

               }

           }

       }

   }



   extension Tab {

       var title: String {

           switch self {

           case .overview:

               return "Overview"

           case .tracks:

               return "Tracks"

           case .playlists:

               return "Playlists"

           case .favorites:

               return "Favorites"

           }

       }

   }



struct MusicPlayerHomeView_Previews: PreviewProvider {

    static var previews: some View {

        MusicPlayerHomeView()

    }

}
