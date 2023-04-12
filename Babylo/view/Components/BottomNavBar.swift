//
//  BottomNavBar.swift
//  Babylo
//
//  Created by Babylo  on 12/4/2023.
//

import SwiftUI

struct BottomNavBar: View {
    
    @Binding var selectedItem : Int
    @State private var showAddBabyView = false
    @StateObject private var babyViewModel = BabyViewModel(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU1OWU1NjFiZjlhNzhlNTNlMjQ5YyIsImlhdCI6MTY4MTIxODA2NX0.DVD3QYKhfTiHz_ftFV8lmXvgggUtuAHIdwGfLrZr8hw")
    
    var body: some View {
    
          
            HStack {
                BottomNavBarItem(image: Image(systemName: "house"), action: {selectedItem=0},isSelected: selectedItem==0).foregroundColor(selectedItem==0 ? .yellow : .gray)
                BottomNavBarItem(image:Image(systemName: "music.note"), action: {selectedItem=1},isSelected: selectedItem==1).foregroundColor(selectedItem==1 ? .yellow : .gray)
                
                NavigationLink(destination: AddBaby().environmentObject(babyViewModel), isActive: $showAddBabyView){
                    addButton
                }
                
                
                BottomNavBarItem(image: Image(systemName: "headphones"), action: {selectedItem=2},isSelected: selectedItem==2).foregroundColor(selectedItem==2 ? .yellow : .gray)
                BottomNavBarItem(image: Image(systemName: "gear"), action: {selectedItem=3},isSelected: selectedItem==3).foregroundColor(selectedItem==3 ? .yellow : .gray)
            }
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 2, y: 6)
        }
    
    private var addButton: some View{
        Button(action:{
            showAddBabyView = true
        }){
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .padding(15)
                .background(Color.yellow)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
        }
    }
}



struct BottomNavBarItem: View {
    let image: Image
    let action: () -> Void
    let isSelected: Bool
    
    var body: some View {
        Button(action: action) {
            image
                .frame(maxWidth: .infinity)
        }
        .foregroundColor(isSelected ? .yellow : .gray)
        .onTapGesture {
            action()
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar(selectedItem: .constant(0))
    }
}

