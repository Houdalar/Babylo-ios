//
//  AudioBookItems.swift
//  Babylo
//
//  Created by houda lariani on 5/5/2023.
//

import SwiftUI

struct AudioBookCardView: View {
    let audioBook: AudioBook
    @State private var showingMusicPlayer = false

    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: audioBook.cover) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.frame(width: 120, height: 160)
                    .cornerRadius(15)
                
            }
                
           /* Text(audioBook.bookTitle)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .padding(.top, 5)*/
        }
        .onTapGesture {
                    showingMusicPlayer = true
                }
                .sheet(isPresented: $showingMusicPlayer) {
                    BookDetailsView(audioBook: audioBook)
                }
    }
}

struct CategoryCardView: View {
    let category: String
    let cover: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            GeometryReader { geometry in
                ZStack {
                    if let url = URL(string: cover) {
                        AsyncImage(url: url) { image in
                            image.scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .blur(radius: 20)
                        .frame(width: geometry.size.width, height: 60)
                        .cornerRadius(20)
                        .clipped()
                        
                    }
                    
                    VStack {
                        Text(category)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                }
            }
            .frame(height: 150)
            .padding(.horizontal)
        }
    }
}

struct CategoryBar: View {
    let categories: [(String, String)]
    let booksByCategory: [String: [AudioBook]]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(categories, id: \.0) { (category, cover) in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 30) {
                                ForEach(booksByCategory[category] ?? [], id: \.id) { book in
                                    AudioBookCardView(audioBook: book)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                }
            }
        }
    }


struct BookShelfCardView: View {
    @StateObject private var viewModel = AudioBookViewModel()
    let audioBook: AudioBook
    @State private var showingActionSheet = false
    var onRemove: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 15) {
                if let url = URL(string: audioBook.cover) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }.frame(width: 100, height: 150)
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 3) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.yellow, lineWidth: 1.5)
                        .frame(width: 70, height: 25)
                        .overlay(
                            Text(audioBook.category)
                                .font(.system(size: 10))
                                .foregroundColor(Color.yellow)
                                .padding(.horizontal, 4)
                        )
                        .padding(.top,10)
                        .padding(.bottom,20)

                    Text(audioBook.bookTitle)
                        .font(.system(size: 16))
                        .fontWeight(.bold)

                    Text("Author: \(audioBook.author)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Text("Narrator: \(audioBook.narrator)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    showingActionSheet = true
                    
                }) {
                    
                    ThreeDotsColumn()
                        
                }
                .actionSheet(isPresented: $showingActionSheet) {
                               ActionSheet(title: Text("Options"), message: nil, buttons: [
                                   .destructive(Text("Remove from Bookshelf")) {
                                       viewModel.removeFromBookShelf(bookId: audioBook.id) { error in
                                           if let error = error {
                                               print("Error removing book from favorites: \(error)")
                                           } else {
                                               print("Book successfully removed from favorites")
                                           }
                                       }
                                   },
                                   .cancel()
                               ])
                           }
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}


struct ThreeDotsColumn: View {
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<3) { _ in
                Circle()
                    .frame(width: 4, height: 4)
                    .foregroundColor(.gray)
            }
        }
    }
}
