//
//  BookShelf.swift
//  Babylo
//
//  Created by Babylo  on 6/5/2023.
//

import SwiftUI

struct BookShelf: View {
    let books: [AudioBook] = [
        AudioBook(id: "1", bookTitle: "Magalina", author: "Andy wisley", cover: "http://localhost:8080/media/AudiobookCovers/Magalina.jpeg", category: "Mystery", description: "A mysterious book", rating: 4.5, url: "url1", listened: 1000, date: "01/01/2022", duration: "6:35:00", narrator: "Salma al khouri", language: "English"),
        
        AudioBook(id: "2", bookTitle: "Princess", author: "Dan brown", cover: "http://localhost:8080/media/AudiobookCovers/princess-and-theGoblin.jpeg", category: "Science Fiction", description: "A sci-fi adventure", rating: 4.0, url: "url2", listened: 2000, date: "01/02/2022", duration: "5:20:00", narrator: "houda", language: "English"),
        
        AudioBook(id: "3", bookTitle: "train street", author: "mark manson", cover: "http://localhost:8080/media/AudiobookCovers/train-street.jpeg", category: "Romance", description: "A romantic tale", rating: 3.5, url: "url3", listened: 1500, date: "01/03/2022", duration: "7:45:00", narrator: "naim", language: "English"),
        
        AudioBook(id: "4", bookTitle: "legend of lotus..", author: "mohamed mostafa", cover: "http://localhost:8080/media/AudiobookCovers/TheGuardianTest.jpeg", category: "History", description: "A historical journey", rating: 4.7, url: "url4", listened: 2500, date: "01/04/2022", duration: "8:20:00", narrator: "ahmed salim", language: "English"),
        
        AudioBook(id: "5", bookTitle: "Rescue at lake..", author: "Hasan el janadi", cover: "http://localhost:8080/media/AudiobookCovers/AuthorTerryLynnJohnson.png", category: "Biography", description: "An inspiring biography", rating: 4.2, url: "url5", listened: 3000, date: "01/05/2022", duration: "6:10:00", narrator: "Laura wind", language: "English"),
        AudioBook(id: "6", bookTitle: "Eli & gaston", author: "gaston tor", cover: "http://localhost:8080/media/AudiobookCovers/eliandgaston.png", category: "Mystery", description: "Another mysterious book", rating: 3.8, url: "url6", listened: 1700, date: "01/06/2022", duration: "5:50:00", narrator: "chadli", language: "English")
        
       ]

       var body: some View {
           ScrollView {
               LazyVStack(alignment: .leading, spacing: 20) {
                   ForEach(books, id: \.id) { book in
                       BookShelfCardView(audioBook: book)
                   }
               }
               .padding(.horizontal)
           }
       }
   }

struct BookShelf_Previews: PreviewProvider {
    static var previews: some View {
        BookShelf()
    }
}
