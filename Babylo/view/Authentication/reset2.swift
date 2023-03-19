//
//  reset2.swift
//  Babylo
//
//  Created by houda lariani on 20/3/2023.
//

import SwiftUI

struct Reset2View: View {
    @State private var email: String = ""
    @State private var isLoading = false
    @State private var code: String = ""
    @State private var isCodeComplete: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Image("Enter OTP-cuate")
                .resizable()
                .frame(width: 280, height: 280 , alignment: .center)
                .padding(.horizontal, 20)
            
            Text("Enter the code")
                .font(Font.system(size: 25))
                .bold()
                .padding(.top,10)
                
                                
            
            Text("we sent you a code via your email")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top,10)
            
            HStack(spacing: 15) {
                ForEach(0..<4) { index in
                    let binding = Binding(
                        get: {
                            String(code.prefix(index+1).suffix(1))
                        },
                        set: {
                            if $0.isEmpty {
                                code = String(code.prefix(index))
                            } else if $0.count == 1 {
                                code = code + $0
                                if index < 3 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            code += " "
                                        }
                                    }
                                }
                                isCodeComplete = code.count == 4
                            }
                        }
                    )
                    CodeBoxView(text: binding, focus: index == code.count-1)
                }
            }
            .padding(.horizontal,20)
            .padding(.top,30)
          
                
            
            
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
                        Text("Verify")
                            .padding(.horizontal,110)
                            .foregroundColor(.black)
                            .padding()
                            .background(isCodeComplete ? Color.yellow : Color.yellow.opacity(0.5))
                            .cornerRadius(30)
                            .frame(maxWidth: .infinity)
                            .disabled(!isCodeComplete)
                        
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
        let signupView = Reset3View()
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

struct CodeBoxView: View {
    @Binding var text: String
    var focus: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(focus ? Color.yellow : Color.gray, lineWidth: 1)
                .frame(width: 60, height: 70, alignment: .center)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if isEditing {
                    self.text = ""
                }
            })
            .font(.title2)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .frame(width: 30, height: 30, alignment: .center)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .accentColor(.clear)
            .border(Color.clear, width: 0)
            .onChange(of: text) { newValue in
                if newValue.count > 1 {
                    text = String(newValue.prefix(1))
                }
            }
        }
    }
}




struct Previews_Reset2_Previews: PreviewProvider {
    static var previews: some View {
        Reset2View()
    }
}
