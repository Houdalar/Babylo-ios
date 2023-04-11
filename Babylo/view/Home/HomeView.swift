//
//  HomeView.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU1OWU1NjFiZjlhNzhlNTNlMjQ5YyIsImlhdCI6MTY4MTIxODA2NX0.DVD3QYKhfTiHz_ftFV8lmXvgggUtuAHIdwGfLrZr8hw"
    
    @StateObject private var babyViewModel : BabyViewModel
    
    init(token: String) {
            _babyViewModel = StateObject(wrappedValue: BabyViewModel(token: token))
        }
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .frame(height: 40)
                            .background(Color.white)
                            .cornerRadius(20)
                        
                        Button(action: {
                            // Handle notifications
                        }) {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.yellow)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    TagLineView().padding()
                    
                   /* ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(AppColors.lightColor).frame(height: 80)
                        
                            
                            Text("Because every moment with your little one is precious !")
                            .font(.title3)
                                .foregroundColor(Color.black)
                                
                        
                        
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    */
            
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            
                           /* ForEach(0..<5) { _ in
                                BabyCardView()
                            }*/
                            
                            ForEach(babyViewModel.babies){
                                baby in BabyCardView(baby: baby)
                            }
                        }
                        
                        .padding(.top, 20)
                        .padding(.trailing)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarHidden(true)
        }.onAppear{
            babyViewModel.fetchBabies()
        }
    }
}

struct TagLineView: View {
    var body: some View {
        Text("Because every moment with your little one is ")
            .font(.custom("DancingScript-VariableFont_wght", size: 20))
            
            + Text("precious !")
            .font(.custom("DancingScript-VariableFont_wght", size: 20))
            .fontWeight(.bold)
            
    }
}

struct BabyCardView: View {
    let baby : Baby
    var body: some View {
        VStack {
            if let babyPic = baby.babyPic , let url = URL(string: babyPic), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData){
                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 210)
                                    .cornerRadius(20)
            }
            else{
                Image("placeholder-image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 210)
                                    .cornerRadius(20)

            }
            Text(baby.babyName)
                            .font(.title3)
                            .fontWeight(.bold)
        }
        .frame(width: 210)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU1OWU1NjFiZjlhNzhlNTNlMjQ5YyIsImlhdCI6MTY4MTIxODA2NX0.DVD3QYKhfTiHz_ftFV8lmXvgggUtuAHIdwGfLrZr8hw")
    }
}



