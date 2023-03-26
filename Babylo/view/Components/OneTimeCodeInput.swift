//
//  OneTimeCodeInput.swift
//  Babylo
//
//  Created by houda lariani on 25/3/2023.
//

import SwiftUI

/*struct OneTimeCodeInput: View {
    @Binding var codeDict: [Int: String]
    @Binding var firstResponderIndex: Int
    let codeDigits: Int = 4
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<codeDigits, id: \.self) { index in
                CodeDigitInput(index: index,
                               codeDict: $codeDict,
                               firstResponderIndex: $firstResponderIndex)
            }
        }
    }
}

struct CodeDigitInput: View {
    let index: Int
    @Binding var codeDict: [Int: String]
    @Binding var firstResponderIndex: Int
    
    var body: some View {
        let isFirstResponder = Binding(
            get: { firstResponderIndex == index },
            set: { if $0 { firstResponderIndex = index } }
        )
        
        let textBinding = Binding(
            get: { codeDict[index, default: ""] },
            set: { codeDict[index] = $0 }
        )
        
        return VStack {
            TextField("", text: textBinding, onEditingChanged: { isFirstResponder.wrappedValue = $0 })
                .frame(width: 60, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                )
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .cornerRadius(4)
                .onTapGesture { isFirstResponder.wrappedValue = true }
                .accentColor(Color(.systemYellow))
                .onChange(of: textBinding.wrappedValue) { newValue in
                    if newValue.count > 0 && index < 3 {
                        firstResponderIndex = index + 1
                    } else if newValue.count == 0 && index > 0 {
                        firstResponderIndex = index - 1
                    }
                }
            
            if firstResponderIndex == index {
                Rectangle()
                    .stroke(Color(.systemYellow), lineWidth: 2)
                    .frame(width: 48, height: 2)
            }
        }
    }
}*/

struct OneTimeCodeInput: View {
    @Binding var codeDict: [Int: String]
    @Binding var firstResponderIndex: Int
    let codeDigits: Int = 4
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<codeDigits, id: \.self) { index in
                CodeDigitInput(index: index,
                               codeDict: $codeDict,
                               firstResponderIndex: $firstResponderIndex)
            }
        }
    }
}

struct CodeDigitInput: View {
    let index: Int
    @Binding var codeDict: [Int: String]
    @Binding var firstResponderIndex: Int
    
    var body: some View {
        let isFirstResponder = Binding(
            get: { firstResponderIndex == index },
            set: { if $0 { firstResponderIndex = index } }
        )
        
        let textBinding = Binding(
            get: { codeDict[index, default: ""] },
            set: { codeDict[index] = $0 }
        )
        
        return VStack {
            TextField("", text: textBinding, onEditingChanged: { isFirstResponder.wrappedValue = $0 })
                .frame(width: 60, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                )
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .cornerRadius(4)
                .onTapGesture { isFirstResponder.wrappedValue = true }
                .accentColor(Color(.systemYellow))
                .onChange(of: textBinding.wrappedValue) { newValue in
                    if newValue.count == 1 && index < 3 {
                        firstResponderIndex = index + 1
                    } else if newValue.count == 0 && index > 0 {
                        firstResponderIndex = index - 1
                    }
                }
            
            if firstResponderIndex == index {
                Rectangle()
                    .stroke(Color(.systemYellow), lineWidth: 2)
                    .frame(width: 48, height: 2)
            }
        }
    }
}

