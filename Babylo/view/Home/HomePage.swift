//
//  HomePage.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomePage: View {
    @State private var isAuthenticated = true
    
    var body: some View {

        TabView{

                            HomeView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU1OWU1NjFiZjlhNzhlNTNlMjQ5YyIsImlhdCI6MTY4MTIxODA2NX0.DVD3QYKhfTiHz_ftFV8lmXvgggUtuAHIdwGfLrZr8hw").tabItem(){

                                Image(systemName: "house")

                                Text("Home")

                            }

                            MusicView().tabItem(){

                                Image(systemName: "music.note")

                                Text("Music")

                            }

                            AudioBooksView().tabItem(){

                                Image(systemName: "headphones")

                                Text("Audiobooks")

                            }

            SettignsView(isAuthenticated: $isAuthenticated).tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
            }

        }.accentColor(.yellow)

    }

    struct HomePage_Previews: PreviewProvider {

        static var previews: some View {

            HomePage()

        }

    }

}

struct MusicView: View {

    var body: some View {

        Text("Music Screen")

    }

}

struct AudioBooksView: View {

    var body: some View {

        Text("Audiobooks Screen")

    }

}

