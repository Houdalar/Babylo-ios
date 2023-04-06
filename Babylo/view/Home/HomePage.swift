//
//  HomePage.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomePage: View {

    var body: some View {

        TabView{

                            HomeView().tabItem(){

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

                            SettignsView().tabItem(){

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



/*struct BabyCardView: View {

    var body: some View {

        VStack {

            Image("baby-image")

                .resizable()

                .aspectRatio(contentMode: .fit)

                .cornerRadius(10)

            

            Text("Nom du bébé")

                .font(.headline)

                .fontWeight(.bold)

        }

        .padding()

        .frame(height: 200)

        .background(Color.white)

        .cornerRadius(10)

        .shadow(radius: 5)

        .padding(.horizontal)

        .frame(width: 300)

        

        

    }

}*/

/*struct HomeView: View{

    @State private var selectedTab = "home"
    @State private var quote = "Loading quote..."
    @State private var searchText = ""
    var body: some View {
        NavigationView{

            VStack{

                List {

                    ForEach(0..<5) { index in

                        NavigationLink(destination: BabyProfile()) {

                            BabyCardView()

                        }

                    }

                }.listStyle(PlainListStyle())

                    .padding()

                    .navigationTitle("Babylo")

                

            }

            

        }

    }
}*/

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

