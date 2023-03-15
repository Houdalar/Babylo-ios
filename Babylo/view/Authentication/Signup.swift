//
//  Signup.swift
//  Babylo
//
//  Created by houda lariani on 14/3/2023.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
                   
        VStack {
            Image("Signup")
                .resizable()
                .frame(width: 300, height: 300 , alignment: .center)
                .padding(.horizontal, 20)
            
            TextField("Email", text: $email)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,40)
            
            TextField("Username", text: $username)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top:0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,10)
            
            SecureField("Password", text: $password)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top:0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,10)
            
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
                    Text("Sign Up")
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
           
            
            
            HStack {
                Text("Have an account ?")
                    .foregroundColor(Color.black)
                    
                
                Button(action: switchToLogin ) {
                    Text("Sign In")
                        .foregroundColor(AppColors.primarydark)
                        .underline()
                        
                    
                }
            }
            .padding(.top,30)
        }
        .padding(.horizontal, 20)
        
    }
    
    private func signUp() {
        // Handle signup logic
    }
    
    private func switchToLogin() {
        let loginView = LoginView()
        let transition = AnyTransition.move(edge: .bottom)
            .animation(.easeInOut(duration: 5))
        let loginViewWithTransition = loginView
            .transition(transition)
        let loginVC = UIHostingController(rootView: loginViewWithTransition)
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController?.present(navController, animated: true, completion: nil)
        
        presentationMode.wrappedValue.dismiss()
    }



}

struct Previews_Signup_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
