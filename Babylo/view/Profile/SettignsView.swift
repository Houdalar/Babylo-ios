//
//  SettignsView.swift
//  Babylo
//
//  Created by Mac2021 on 15/3/2023.
//

import SwiftUI

struct SettignsView: View {
    @State var notifEnabled : Bool = true
    @State var previewIndex = 0
    var body: some View {
        NavigationView{
            Form{
                Section(header:Text("NOTIFICATIONS")){
                    Toggle(isOn: $notifEnabled){
                        Text("Enable notifications")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: !notifEnabled ? Color.gray :  Color.yellow))
                }
                
                Section(header:Text("Account")){
                    HStack{
                        Text("Change username")
                        Spacer(minLength: 15)
                        Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                    }
                    HStack(spacing:10){
                        Image("key")
                            .resizable()
                            .frame(width: 16,height: 16)
                        Text("Change password")
                        Spacer(minLength: 15)
                        Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                    }

                }
                
                Section{
                    HStack{
                        Text("About us")
                        Spacer(minLength: 15)
                        Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                    }
                }
                        
                Section{
                    HStack(spacing:10){
                        Image("logout")
                            .resizable()
                            .frame(width: 20,height: 20)
                        Text("Logout")
                        Spacer(minLength: 15)
                        Image(systemName: "chevron.right").foregroundColor(Color.yellow)
                    }
                }
            }
            .navigationTitle("Settings")
            
        }
    }
}

struct SettignsView_Previews: PreviewProvider {
    static var previews: some View {
        SettignsView()
    }
}
