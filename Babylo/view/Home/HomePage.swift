//
//  HomePage.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomePage: View {
    @State private var isAuthenticated = true
    @State private var selectedIndex = 0
    
    @State private var userToken : String = UserDefaults.standard.string(forKey: "token") ?? ""
    
    var body: some View {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)

                switch selectedIndex {
                case 0:
                    HomeScreen(token: userToken)
                case 1:
                    MusicPlayerHomeView()
                case 2:
                    AudioBookHomePage()
                case 3:
                    SettignsView(isAuthenticated: $isAuthenticated)
                default:
                    Text("Something went wrong.")
                }

                VStack {
                    Spacer() // Push the custom tab bar to the bottom
                    BottomNavBar(selectedIndex: $selectedIndex)
                }
            }
        }
    }


    

    struct HomePage_Previews: PreviewProvider {

        static var previews: some View {

            HomePage()

        }

    }

    
