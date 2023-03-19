//
//  SettignsView.swift
//  Babylo
//
//  Created by Mac2021 on 15/3/2023.
//

import SwiftUI

struct SettignsView: View {
    @State var notifEnabled: Bool = true
    @State var previewIndex = 0
    @State var showUsernameDialog = false
    @State var username = "John Doe"
    @State var showpasswordDialog = false
    @State var curentPassword = ""
    @State var newPassword = ""
    
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
                        Text("Logout")
                        Spacer(minLength: 15)
                        Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Change your username", isPresented: $showUsernameDialog, actions: {
                        TextField("Username", text: $username)
                        Button("save", action: {updateUsername()})
                        Button("Cancel", role: .cancel, action: {})
                    }, message: {
                        Text("Enter your new username")
                    })
            .navigationTitle("Settings")
            .alert("Change your Password", isPresented: $showpasswordDialog, actions: {
                        TextField("Current password", text: $curentPassword)
                        TextField("New password", text: $newPassword)
                        Button("save", action: {updateUsername()})
                        Button("Cancel", role: .cancel, action: {})
                    }, message: {
                        
                            
                    })
       
        }
    }
    
    func updateUsername() {
        // TODO: Call the API to update the username
    }
}


struct SettignsView_Previews: PreviewProvider {
    static var previews: some View {
        SettignsView()
    }
}
