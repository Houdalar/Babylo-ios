//
//  Rootview.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct RootView: View {
    @State private var showIntro: Bool = UserDefaults.standard.bool(forKey: "hasShownIntro") ? false : true
    @State private var showLogin: Bool = false

    var body: some View {
        ZStack {
            if showIntro {
                IntroView(onFinish: {
                    UserDefaults.standard.set(true, forKey: "hasShownIntro")
                    showIntro = false
                    showLogin = true
                })
            } else{
                // Replace 'LoginView()' with your actual login view
                LoginView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

