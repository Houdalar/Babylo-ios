//
//  HomePage.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomePage: View {
    @State private var isAuthenticated = true
    @State private var selectedItem = 0
    
    @State private var userToken : String = UserDefaults.standard.string(forKey: "token") ?? ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                switch selectedItem{
                case 0 :
                    HomeScreen(token: userToken)
                    
                case 1 :
                    MusicView()
                case 2:
                    AudioBooksView()
                case 3:
                    SettignsView(isAuthenticated: $isAuthenticated)
                default:
                    HomeView(token: userToken)
                }
                Spacer()
                BottomNavBar(selectedItem: $selectedItem,token: userToken)
            }
        }
        

        
    }
    
    init(){
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName){
                print ("-- \(fontName)")
            }
        }
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

