//
//  HeightView.swift
//  Babylo
//
//  Created by Babylo  on 25/4/2023.
//

import SwiftUI

struct HeightView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var babyViewModel: BabyViewModel
    let babyName: String

    @State private var selectedTab: Int = 0
    @State private var showAddHeightModal: Bool = false
    
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }.foregroundColor(.black)
                    .padding()

                Spacer()
            }
            
            TopTabView(tabIndex: $selectedTab,text1: "Height",text2: "Growth")
            
            if selectedTab == 0 {
                HeightTabView(babyViewModel: babyViewModel, babyName: babyName)
            }
            else{
                HeightChartView(babyViewModel: babyViewModel)
            }
            Spacer()
        }
        
    }
}

struct HeightView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleViewModel = BabyViewModel()
        return HeightView( babyViewModel: BabyViewModel(token: UserDefaults.standard.string(forKey: "token") ?? ""), babyName: "test")
    }
}

