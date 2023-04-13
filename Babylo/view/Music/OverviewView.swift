//
//  OverviewView.swift
//  Babylo
//
//  Created by houda lariani on 11/4/2023.
//

import SwiftUI

struct OverviewView: View {
    @State private var currentPage = 0
    let timer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    @State private var trendingLabelOpacity = 0.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        TabView(selection: $currentPage) {
                            ForEach(0..<5) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: geometry.size.width - 40, height: geometry.size.height - 20)
                                    
                                    VStack {
                                        ZStack(alignment: .bottomLeading) {
                                            Image("Mamafrog")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width - 40, height: geometry.size.height - 20)
                                                .clipped()
                                                .cornerRadius(20)
                                            
                                            Text("Album \(index + 1)")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding()
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                            
                                            Text("new")
                                            .font(.system(size: 16, weight: .bold))
                                            .opacity(trendingLabelOpacity)
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .background(Color.yellow)
                                            .cornerRadius(10)
                                            .padding(.top, 10)
                                            .padding(.trailing, 10)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .onReceive(timer) { _ in
                                                    withAnimation {
                                                        currentPage = (currentPage + 1) % 5
                                                    }
                                                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                                        trendingLabelOpacity = trendingLabelOpacity == 1.0 ? 0.0 : 1.0
                                                    }
                                        }
                                                .padding(.top,20)
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .frame(height: 250)
                                .padding(.bottom)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration:1).repeatForever(autoreverses: true)) {
                                        trendingLabelOpacity = 1.0
                                    }
                                }

                HStack {
                    Spacer()
                    PageControl(numberOfPages: 5, currentPage: $currentPage, dotColor: AppColors.primarydark)
                        .padding(.trailing)
                }
                .padding(.bottom, -30)
                .padding(.top,-5)

                VStack(alignment: .leading) {
                                   HStack {
                                       Text("Trending")
                                           .font(.system(size: 20))
                                           .padding(.leading)

                                       Spacer()

                                       Button(action: {
                                           // Handle "See All" button tap
                                       }) {
                                           Text("See All")
                                               .foregroundColor(.gray)
                                               .padding(.trailing)
                                       }
                                   }
                                   .padding(.top, 20) // Add padding here to lower the section

                                   ScrollView(.horizontal, showsIndicators: false) {
                                       LazyHStack(spacing: 30) {
                                           ForEach(0..<10) { index in
                                               VStack(alignment: .leading) { // Add alignment here
                                                   Image("Duck")
                                                       .resizable()
                                                       .scaledToFit()
                                                       .frame(width: 100, height: 100)
                                                       .cornerRadius(20)

                                                   Text("Track \(index + 1)")
                                                       .font(.system(size: 14))
                                                       .fontWeight(.semibold)
                                                       .padding(.top, 5)

                                                   Text("Artist Name")
                                                       .font(.system(size: 12))
                                                       .foregroundColor(.gray)
                                               }
                                           }
                                       }
                                       .padding(.horizontal)
                                   }
                               }
                               .padding(.top, 10)

                               // Albums section
                               VStack(alignment: .leading) {
                                   HStack {
                                       Text("Albums")
                                           .font(.system(size: 20))
                                           .padding(.leading)

                                       Spacer()

                                       Button(action: {
                                           // Handle "See All" button tap
                                       }) {
                                           Text("See All")
                                               .foregroundColor(.gray)
                                               .padding(.trailing)
                                       }
                                   }
                                   .padding(.top)

                                   ScrollView(.horizontal, showsIndicators: false) {
                                     LazyHStack(spacing: 20) {
                                         ForEach(0..<5) { index in
                                             VStack(alignment: .leading) {
                                                 ZStack(alignment: .topLeading) {
                                                        RoundedRectangle(cornerRadius: 30) // Add RoundedRectangle for rounded edges
                                                                               .fill(Color.gray.opacity(0.1))
                                                                               .frame(width: 160, height: 160)
                                                                           
                                                                           Image("Aesthetic Cat in a Starry Forest")
                                                                               .resizable()
                                                                               .scaledToFit()
                                                                               .frame(width: 170, height: 170)
                                                                               .cornerRadius(20)

                                                                           Text("Category")
                                                                               .font(.system(size: 14, weight: .bold))
                                                                               .foregroundColor(Color.brown.opacity(0.8)) // Use a darker yellow color
                                                                               .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                                                                               .background(Color.white) // Set background color to white
                                                                               .cornerRadius(30)
                                                                               .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0)) // Add padding to create spacing
                                                                       }

                                                                       Text("Album \(index + 1)")
                                                                           .font(.system(size: 14))
                                                                           .fontWeight(.semibold)
                                                                           .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
                                                                   }
                                                               }
                                                           }
                                                           .padding(.horizontal)
                                                       }
                                                   }
                                                   .padding(.top, 10)
                                               }
                                           }
                                       }
                                   }

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
