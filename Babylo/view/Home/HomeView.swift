//
//  HomeView.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
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
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.white)
                        
                        VStack(alignment: .leading) {
                            Text("Quote of the day")
                                .font(.headline)
                                .foregroundColor(Color.black)
                                .padding(.bottom, 5)
                            
                            Text("The only limit to our realization of tomorrow will be our doubts of today.")
                                .font(.body)
                                .foregroundColor(Color.black)
                                .padding(.bottom, 20)
                        }
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    Text("Babies")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<5) { _ in
                                BabyCardView()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct BabyCardView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("baby-image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            Text("Baby Name")
                .foregroundColor(Color.black)
                .font(.headline)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

