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
    @State private var showSignup: Bool = false
    @ObservedObject var viewModel = UserViewModel()

    var body: some View {
        ZStack {
            if showIntro {
                IntroView(onFinish: { signUpSelected in
                    UserDefaults.standard.set(true, forKey: "hasShownIntro")
                    showIntro = false
                    if signUpSelected {
                        showSignup = true
                    } else {
                        showLogin = true
                    }
                })
            } else if showLogin {
                // Replace 'LoginView()' with your actual login view
                LoginView()
            } else if showSignup {
                // Replace 'SignupView()' with your actual signup view
                SignupView()
            }
            else{
                LoginView()
            }
            
            if viewModel.isAuthenticated {
                // Replace 'MainAppView()' with your actual main app view
                HomePage()
            } else {
                LoginView(viewModel: viewModel)
            }

        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

