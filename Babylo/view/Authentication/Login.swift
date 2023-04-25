//
//  Login.swift
//  Babylo
//
//  Created by houda lariani on 14/3/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var isActive = false
    @State private var isSignupActive = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var isLoading = false
    @State private var rememberMe = false
    @State private var emailError: String = ""
    @State private var passwordError: String = ""
    @ObservedObject var viewModel = UserViewModel()
    @State private var showError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isReset1Active = false
    @State private var isHomeActive = false
    @Environment(\.presentationMode) var presentationMode
    let musicViewModel = MusicViewModel()
    
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
                    
                    
                    
                    Button(
                        action: {
                            isReset1Active = true
                        }) {
                            
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
                    
                    
                    NavigationLink(
                                            destination: SignupView().navigationBarHidden(true),
                                            isActive: $isSignupActive
                                        ) {
                                            Text("Sign up")
                                                .foregroundColor(AppColors.primarydark)
                                                .underline()
                                        }
                }
                .padding(.top,30)
            }
            .padding(.horizontal, 20)
            .disabled(viewModel.isLoading)
            .alert(isPresented: $showError) {
                Alert(title: Text(errorTitle).foregroundColor(.red), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
            .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
                isActive = isAuthenticated
                
            }
            .background(
                ZStack {
                        NavigationLink(
                            destination: Reset1View().navigationBarHidden(false),
                            isActive: $isReset1Active
                        ) { EmptyView() }
                        
                        NavigationLink(
                            destination:  HomePage()
                                .environmentObject(musicViewModel).navigationBarHidden(true),
                            isActive: $isHomeActive
                        ) { EmptyView() }
                    })
          
        }
      
    }
    
    private func signUp() {
        viewModel.login(email: email, password: password, onSuccess: { token in
            isHomeActive=true
           
        }, onFailure: { title, message in
            // Show dialog with title and message
            errorTitle = title
            errorMessage = message
            showError = true
        })
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





