//
//  SettignsView.swift
//  Babylo
//
//  Created by Mac2021 on 15/3/2023.
//

import SwiftUI
import UserNotifications

struct SettignsView: View {
    @State var notifEnabled: Bool = true
    @State var previewIndex = 0
    @State var showUsernameDialog = false
    @State var username = UserDefaults.standard.string(forKey: "username") ?? "username"
    @State var id = UserDefaults.standard.string(forKey: "token") ?? ""
    @State var showpasswordDialog = false
    @State var curentPassword = ""
    @State var newPassword = ""
    @ObservedObject var viewModel = UserViewModel()
    @State private var showError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showLogoutConfirmation = false
    @Binding var isAuthenticated: Bool
    @State private var isLoggedIn = false

    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NOTIFICATIONS")) {
                    Toggle(isOn: $notifEnabled) {
                        Text("Enable notifications")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: !notifEnabled ? Color.gray : Color.yellow))
                }
                
                Section(header: Text("Account")) {
                    Button(action: {
                        // Show the "Change username" dialog
                        showUsernameDialog = true
                    }) {
                        HStack {
                            Text("Change username")
                                .foregroundColor(Color.black)
                            Spacer(minLength: 15)
                            Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                        }
                    }
                   
                        Button(action: {
                            
                            showpasswordDialog = true
                        }) {
                            HStack {
                                Text("Change Password")
                                    .foregroundColor(Color.black)
                                Spacer(minLength: 15)
                                Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                            }
                        }
                    
            
                }
                
                Section {
                    HStack {
                        Text("About us")
                        Spacer(minLength: 15)
                        Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                    }
                }
                
                Section {
                    HStack(spacing: 10) {
                        Image("logout")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Button(action: {
                            viewModel.logout()
                            showLogoutConfirmation = true
                            isLoggedIn=true
                        }) {
                            HStack {
                                Text("Logout")
                                    .foregroundColor(.black)
                                Spacer(minLength: 15)
                                Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                            }
                        }
                    }
                }

            }
            .alert(isPresented: $showError) {
                Alert(title: Text(errorTitle).foregroundColor(.red), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showLogoutConfirmation) {
                Alert(title: Text("Logout"),
                      message: Text("Are you sure you want to logout?"),
                      primaryButton: .destructive(Text("Logout")) {
                          viewModel.logout()
                          isAuthenticated = false
                      },
                      secondaryButton: .cancel())
            }
            .background(
                
                        NavigationLink(
                            destination: LoginView().navigationBarHidden(false),
                            isActive: $isLoggedIn
                        ) { EmptyView() }
                    )


            .navigationTitle("Settings")
            .alert("Change your username", isPresented: $showUsernameDialog, actions: {
                TextField("Username", text: $username)
                Button("save", action: {if !username.isEmpty {updateUsername()}})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Enter your new username")
            })
            .navigationTitle("Settings")
            .alert("Change your Password", isPresented: $showpasswordDialog, actions: {
                SecureField("Current password", text: $curentPassword)
                SecureField("New password", text: $newPassword)
                Button("save", action: {if !curentPassword.isEmpty && !newPassword.isEmpty {
                    updatepassword()}})
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                
                
            })
            
        }
    }
    
    func updateUsername() {
        viewModel.updateUsername(token: id , username: username ,onSuccess: { title, message in
            errorTitle = title
            errorMessage = message
            showError = true
        }, onFailure: { title, message in
            // Show dialog with title and message
            errorTitle = title
            errorMessage = message
            showError = true
        })
    }
    
    func updatepassword() {
        viewModel.updatepassword(token:id, password: curentPassword , newpassword :newPassword ,onSuccess: { title, message in
            errorTitle = title
            errorMessage = message
            showError = true
            curentPassword = ""
            newPassword = ""
        }, onFailure: { title, message in
            // Show dialog with title and message
            errorTitle = title
            errorMessage = message
            showError = true
            curentPassword = ""
            newPassword = ""
        })
    }
}



struct SettignsView_Previews: PreviewProvider {
    @State static private var isAuthenticated = true

    static var previews: some View {
        SettignsView(isAuthenticated: $isAuthenticated)
    }
}
