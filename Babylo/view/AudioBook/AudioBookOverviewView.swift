//
//  AudioBookOverviewView.swift
//  Babylo
//
//  Created by houda lariani on 5/5/2023.
//

import SwiftUI

struct AudioBookOverviewView: View {
    @StateObject private var viewModel = AudioBookViewModel()
    let categories: [(String, String)] = [
        ("Adventure", "http://localhost:8080/media/images/MattRockefeller.png1683522421785.png"),
        ("Fiction", "http://localhost:8080/media/images/OfaFeather.jpeg1683525106258.jpg"),
        ("Mystery", "http://localhost:8080/media/AudiobookCovers/mystery_cover.jpeg")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // New releases section
                    sectionHeader(title: "New Releases")
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30) {
                            ForEach(viewModel.newestAudioBooks) { book in
                                NavigationLink(destination: BookDetailsView(audioBook: book)) {
                                    AudioBookCardView(audioBook: book)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    .onAppear(perform: viewModel.fetchNewestAudioBooks)
                    
                    // Popular books section
                    sectionHeader(title: "Popular Books")
                        .padding(.top, 20)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30) {
                            ForEach(viewModel.topAudioBooks) { book in
                                NavigationLink(destination: BookDetailsView(audioBook: book)) {
                                    AudioBookCardView(audioBook: book)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    .onAppear(perform: viewModel.fetchTopAudioBooks)
                    
                
                                // Adventure Category
                                CategoryCardView(category: categories[0].0, cover: categories[0].1)
                                    .padding(.top, 20)
                                CategoryBar(categories: [categories[0]], booksByCategory: viewModel.booksByCategory)
                                    .padding(.top, -60)
                                
                                // Fiction Category
                                CategoryCardView(category: categories[1].0, cover: categories[1].1)
                                    .padding(.top, 20)
                                CategoryBar(categories: [categories[1]], booksByCategory: viewModel.booksByCategory)
                                    .padding(.top, -60)

                                
                            }
                            .onAppear {
                                for category in categories {
                                    viewModel.fetchAudioBooksByCategory(category: category.0)
                                }
                    
                }
            }
            
        }
           
        }
    

    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
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
    }
}

struct AudioBookOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AudioBookOverviewView()
    }
}
