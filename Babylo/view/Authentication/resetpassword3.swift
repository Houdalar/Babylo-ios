//
//  resetpassword3.swift
//  Babylo
//
//  Created by houda lariani on 15/3/2023.
//

import SwiftUI

struct Reset3View: View {
    @State private var email: String = ""
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Image("Process-pana")
                .resizable()
                .frame(width: 300, height: 300 , alignment: .center)
                .padding(.horizontal, 20)
            
            Text("Last step !")
                .font(Font.system(size: 25))
                .bold()
                
                                
            
            Text("Set your new password")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top,10)
            
            TextField("New Password", text: $email)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,30)
            
            TextField("Confirm Password", text: $email)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,15)
            

            Button(
                action: {
                    // Perform sign up action
                    withAnimation {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isLoading = false
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                            .scaleEffect(2)
                            .padding()
                    } else {
                        Text("Save")
                            .padding(.horizontal,110)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(30)
                            .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            
            Spacer()
        }
        
    }
    
    private func send() {
        // Handle signup logic
    }
    
    private func switchToSignup() {
        let signupView = SignupView()
        let transition = AnyTransition.move(edge: .bottom)
            .animation(.easeInOut(duration: 2))
        let signupViewWithTransition = signupView
            .transition(transition)
        let signupVC = UIHostingController(rootView: signupViewWithTransition)
        let navController = UINavigationController(rootViewController: signupVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        
        if let windowScene = UIApplication.shared.windows.first?.windowScene {
            windowScene.windows.first?.rootViewController?.present(navController, animated: true, completion: nil)
        }
        signupView.presentationMode.wrappedValue.dismiss()
    }

}

struct Previews_Reset3_Previews: PreviewProvider {
    static var previews: some View {
        Reset3View()
    }
}


