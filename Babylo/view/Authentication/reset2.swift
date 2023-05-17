//
//  reset2.swift
//  Babylo
//
//  Created by houda lariani on 20/3/2023.
//

import SwiftUI

struct Reset2View: View {
    let token: String
    var email: String
    @State private var isLoading = false
    @State private var code: String = ""
    @State private var isCodeComplete: Bool = false
    @State private var focusIndex = 0
    @State private var codeDict = [Int: String]()
    @State private var firstResponderIndex = 0
    @State private var isReset3Active = false
    @State private var isShowingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                
                /* HStack(spacing: 15) {
                 /*  OneTimeCodeInput(codeDict: $codeDict, firstResponderIndex: $firstResponderIndex)*/
                 
                 }
                 .padding(.horizontal,20)
                 .padding(.top,30)*/
                
                TextField("Code", text: $code, onEditingChanged: { isEditing in
                    if !isEditing {
                       // isCodeComplete = code.count == 4
                    }
                }, onCommit: {
                    //  isCodeComplete = code.count == 4
                })
                .font(.title2)
                .keyboardType(.numberPad)
                .frame(width: 120, height: 70)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 15).strokeBorder(Color.gray, lineWidth: 1))
                .padding(.top, 30)
                .disabled(isCodeComplete)
                .onReceive(code.publisher.collect()) { newValue in
                    isCodeComplete = newValue.count == 4
                }
                
                
                Button(
                    action: {
                        // Perform sign up action
                        withAnimation {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isLoading = false
                                if token == code {
                                    isReset3Active = true
                                        } else {
                                            isShowingAlert = true
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
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Wrong code").foregroundColor(.red), message: Text("Please check the code we sent you via your email"), dismissButton: .default(Text("OK")) {
                })
            }

            .background(
                            NavigationLink(
                                destination: Reset3View(email: email),
                                isActive: $isReset3Active
                            ) { EmptyView() }
                            .hidden()
                        )
            
        }}
        
    
        
    
    private func send() {
        // Handle signup logic
    }
    

}

struct CodeBoxView: View {
    @Binding var text: String
    var focus: Bool
    var nextResponder: (() -> Void)?
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(focus ? Color.yellow : Color.gray, lineWidth: 1)
                .frame(width: 60, height: 70, alignment: .center)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if isEditing {
                    self.text = ""
                }
            }, onCommit: {
                nextResponder?()
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
        Reset2View(token :"1234" , email :"")
    }
}
