//
//  Login.swift
//  Babylo
//
//  Created by houda lariani on 14/3/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var isLoading = false
    @State private var rememberMe = false
    @State private var emailError: String = ""
    @State private var passwordError: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
        VStack {
            Image("Authentication-bro")
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
            
            Text(emailError)
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .padding(.top, 0)
                .font(Font.system(size: 13))
                .multilineTextAlignment(.leading)
            
            SecureField("Password", text: $password)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top:0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,10)
            
            Text(passwordError)
                .multilineTextAlignment(.leading)
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .padding(.top, 0)
                .font(Font.system(size: 13))
            
            HStack(alignment: .firstTextBaseline){
                Toggle(isOn: $rememberMe) {
                    Text("Remember me")
                        .font(Font.system(size: 15))
                        
                }
                .toggleStyle(CheckboxStyle())
                .padding(.horizontal, 15)
                .padding(.top,15)
                
                NavigationLink(destination: Reset1View()){
                    Text("Forgot Password?")
                        .foregroundColor(AppColors.primarydark)
                        .underline()
                        .padding(.horizontal, 20)
                        .font(Font.system(size: 15))
                }
            }
            
            
            Button(
                action: {
                // Perform sign up action
                withAnimation {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isLoading = false
                        if verify() {
                                        signUp()
                                    }
                    }
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        .scaleEffect(2)
                        .padding()
                } else {
                    Text("Sign In")
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
                    
                
                Button(action: switchToSignup) {
                    Text("Sign up")
                        .foregroundColor(AppColors.primarydark)
                        .underline()
                        
                    
                }
            }
            .padding(.top,30)
        }
        .padding(.horizontal, 20)
        
        
    }
    }
    
    private func signUp() {
        // Handle signup logic
    }
    
    private func verify() -> Bool {
        var isValid = true
        
        if email.isEmpty {
            emailError = "Please enter your email"
        }
        else if   !email.isValidEmail {
            emailError = "Invalid email address"
            isValid = false
        }
        else {
            emailError = ""
        }
        
        
        if password.isEmpty  {
            passwordError = "Please enter your password"
            isValid = false
        } else {
            passwordError = ""
        }
        
        return isValid
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

struct Previews_Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
            
            return HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(configuration.isOn ? .yellow : .gray.opacity(0.6))
                    .font(.system(size: 20, weight: .regular, design: .default))
                
                configuration.label
                
                Spacer() // Add Spacer to align checkbox to the left
            }
            .padding(.horizontal,10)
            .onTapGesture { configuration.isOn.toggle() }
        }
}
