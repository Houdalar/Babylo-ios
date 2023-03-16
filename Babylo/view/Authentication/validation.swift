//
//  validation.swift
//  Babylo
//
//  Created by houda lariani on 15/3/2023.
//
import SwiftUI

struct ResetPassword: View {
    @State private var code: String = ""
    @State private var isCodeComplete: Bool = false

    var body: some View {
        VStack {
            Text("Please enter the code we sent you in the email")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 20) {
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
                    CodeBoxView(text: binding, isFocused: index == code.count-1)
                }
            }
            .padding(.horizontal,20)
            .padding()

            Button(action: {
                // Do something on verification
            }) {
                Text("Verify")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isCodeComplete ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .disabled(!isCodeComplete)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}



struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}

