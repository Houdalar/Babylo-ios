//
//  BookShelf.swift
//  Babylo
//
//  Created by Babylo  on 6/5/2023.
//

import SwiftUI

struct BookShelf: View {
    @StateObject private var viewModel = AudioBookViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.bookShelf, id: \.id) { book in
                    BookShelfCardView(audioBook: book)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchBookShelf()
        }
    }
}

struct BookShelf_Previews: PreviewProvider {
    static var previews: some View {
        BookShelf()
    }
}
