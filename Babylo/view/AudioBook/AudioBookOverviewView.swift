//
//  AudioBookOverviewView.swift
//  Babylo
//
//  Created by houda lariani on 5/5/2023.
//

import SwiftUI

struct AudioBookOverviewView: View {
    @State private var currentPage = 0
    @State private var trendingLabelOpacity = 0.0

    let newReleases = [
        AudioBook(id: "1", bookTitle: "Magalina", author: "Author 1", cover: "http://localhost:8080/media/AudiobookCovers/Magalina.jpeg", category: "Mystery", description: "A mysterious book", rating: 4.5, url: "url1", listened: 1000, date: "01/01/2022", duration: "6:35:00", narrator: "Narrator 1", language: "English"),
        AudioBook(id: "2", bookTitle: "Princess", author: "Author 2", cover: "http://localhost:8080/media/AudiobookCovers/princess-and-theGoblin.jpeg", category: "Science Fiction", description: "A sci-fi adventure", rating: 4.0, url: "url2", listened: 2000, date: "01/02/2022", duration: "5:20:00", narrator: "Narrator 2", language: "English"),
        AudioBook(id: "3", bookTitle: "train street", author: "Author 3", cover: "http://localhost:8080/media/AudiobookCovers/train-street.jpeg", category: "Romance", description: "A romantic tale ", rating: 2.5, url: "url3", listened: 1500, date: "01/03/2022", duration: "7:45:00", narrator: "Narrator 3", language: "English")
    ]

    let popularBooks = [
        AudioBook(id: "4", bookTitle: "legend of lotus..", author: "Author 4", cover: "http://localhost:8080/media/AudiobookCovers/TheGuardianTest.jpeg", category: "History", description: "A historical journey", rating: 4.7, url: "url4", listened: 2500, date: "01/04/2022", duration: "8:20:00", narrator: "Narrator 4", language: "English"),
        AudioBook(id: "5", bookTitle: "Rescue at lake..", author: "Author 5", cover: "http://localhost:8080/media/AudiobookCovers/AuthorTerryLynnJohnson.png", category: "Biography", description: "An inspiring biography", rating: 4.2, url: "url5", listened: 3000, date: "01/05/2022", duration: "6:10:00", narrator: "Narrator 5", language: "English"),
        AudioBook(id: "6", bookTitle: "Eli & gaston", author: "Author 6", cover: "http://localhost:8080/media/AudiobookCovers/eliandgaston.png", category: "Mystery", description: "Another mysterious book", rating: 2, url: "url6", listened: 1700, date: "01/06/2022", duration: "5:50:00", narrator: "Narrator 6", language: "English")
    ]

    let categories: [(String, String)] = [
        ("Mystery", "http://localhost:8080/media/AudiobookCovers/TalesoftheArabianNightsbookcoverIllustration.png"),
        ("Science Fiction", "http://localhost:8080/media/AudiobookCovers/eliandgaston.png"),
        ("Romance", "http://localhost:8080/media/AudiobookCovers/princess-and-theGoblin.jpeg")
    ]
    
    let booksByCategory: [String: [AudioBook]] = [
            "Mystery": [
                AudioBook(id: "4", bookTitle: "Aribian night", author: "Author 4", cover: "http://localhost:8080/media/AudiobookCovers/TalesoftheArabianNightsbookcoverIllustration.png", category: "History", description: "A historical journey", rating: 4.7, url: "url4", listened: 2500, date: "01/04/2022", duration: "8:20:00", narrator: "Narrator 4", language: "English"),
                AudioBook(id: "5", bookTitle: "Alis", author: "Author 5", cover: "http://localhost:8080/media/AudiobookCovers/MyCollections.png", category: "Biography", description: "An inspiring biography", rating: 4.2, url: "url5", listened: 3000, date: "01/05/2022", duration: "6:10:00", narrator: "Narrator 5", language: "English"),
                AudioBook(id: "6", bookTitle: "Eli & gaston", author: "Author 6", cover: "http://localhost:8080/media/AudiobookCovers/eliandgaston.png", category: "Mystery", description: "Another mysterious book", rating: 3.8, url: "url6", listened: 1700, date: "01/06/2022", duration: "5:50:00", narrator: "Narrator 6", language: "English")
            ],
            
        ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // New releases section
                sectionHeader(title: "New Releases")
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 30) {
                        ForEach(newReleases) { book in
                            AudioBookCardView(audioBook: book)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                // Popular books section
                sectionHeader(title: "Popular Books")
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 30) {
                        ForEach(popularBooks) { book in
                            AudioBookCardView(audioBook: book)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                // Categories section
                sectionHeader(title: "Categories")
                CategoryCardView(category: "Mystery", cover: "http://localhost:8080/media/AudiobookCovers/hp.jpeg")
                    .padding(.top, 10)
                CategoryBar(categories: categories,booksByCategory: booksByCategory)
                    .padding(.top, -60)
                CategoryCardView(category: "fiction", cover: "http://localhost:8080/media/AudiobookCovers/eliandgaston.png")
                    .padding(.top, 10)
                CategoryBar(categories: categories,booksByCategory: booksByCategory)
                    .padding(.top, -65)
                                   
                            
            }
            
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                trendingLabelOpacity = 1.0
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
