//
//  TopTabBar.swift
//  Babylo
//
//  Created by Babylo  on 25/4/2023.
//

import SwiftUI

struct TopTabView: View {
    @Binding var tabIndex: Int
    let text1 : String
    let text2 : String
    
    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            TabBarButton1(text: text1, isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButton1(text: text2, isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
        }
        
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TopTabView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var tabIndex: Int = 1

        var body: some View {
            TopTabView(tabIndex: $tabIndex,text1: "view 1", text2: "view 2")
        }
    }
}


struct Underlined: ViewModifier {
    var isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: isSelected ? 2 : 1)
                    .foregroundColor(isSelected ? .yellow : Color.yellow.opacity(0.9))
                , alignment: .bottom)
    }
}

struct TabBarButton1: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("Avenir", size: 20))
            .padding(.bottom, 10)
            .modifier(Underlined(isSelected: isSelected))
    }
}

