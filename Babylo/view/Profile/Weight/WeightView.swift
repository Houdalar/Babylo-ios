//
//  WeightView.swift
//  Babylo
//
//  Created by Babylo  on 26/4/2023.
//

import SwiftUI

struct WeightView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var babyViewModel: BabyViewModel
    let babyName: String

    @State private var selectedTab: Int = 0
    @State private var showAddWeightModal: Bool = false
    
    
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
            
            TopTabView(tabIndex: $selectedTab,text1: "Weight",text2: "Growth")
            
            if selectedTab == 0 {
                WeightTabView(babyViewModel: babyViewModel, babyName: babyName)
            }
            else{
                WeightGrowthTab(babyViewModel: babyViewModel)
            }
            Spacer()
        }
        
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleViewModel = BabyViewModel()
        WeightView(babyViewModel: BabyViewModel(token: UserDefaults.standard.string(forKey: "token") ?? ""), babyName: "test")
    }
}
