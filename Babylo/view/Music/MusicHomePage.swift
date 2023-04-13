//
//  MusicHomePage.swift
//  Babylo
//
//  Created by houda lariani on 11/4/2023.
//

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
                   //    TracksView()
                   }
               case .playlists:
                   NavigationView {
                       PlaylistView()
                   }
               case .favorites:
                   NavigationView {
                     //  FavoritesView()
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
