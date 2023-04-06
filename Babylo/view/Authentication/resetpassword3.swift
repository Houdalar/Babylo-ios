//
//  resetpassword3.swift
//  Babylo
//
//  Created by houda lariani on 15/3/2023.
//

import SwiftUI

struct Reset3View: View {
    var email: String
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var isLoading = false
    @State private var isShowingAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @ObservedObject var viewModel = UserViewModel()
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
            
            TextField("New Password", text: $password)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,30)
            
            TextField("Confirm Password", text: $confirmpassword)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isLoading = false
                            if validate(password: password, confirmPassword: confirmpassword){
                                reset()
                            }
                            else {
                                
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
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(alertTitle).foregroundColor(.red), message: Text(alertMessage), dismissButton: .default(Text("OK")))
           }
        
    }
    
    private func reset() {
        viewModel.resetPassword(email: self.email, password : password , onSuccess: { title, message in
            alertTitle = title
            alertMessage = message
            isShowingAlert = true
        }, onFailure: { title, message in
            alertTitle = title
            alertMessage = message
            isShowingAlert = true
        })
    }
        
    
    func validate(password: String, confirmPassword: String) -> Bool {
        if password != confirmPassword {
                alertTitle = "Passwords don't match"
                alertMessage = "Please make sure your passwords match and try again."
                isShowingAlert = true
                return false
            } else {
                return true
            }
    }
    

}

struct Previews_Reset3_Previews: PreviewProvider {
    static var previews: some View {
        Reset3View(email:"")
    }
}


