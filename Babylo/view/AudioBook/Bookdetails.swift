import SwiftUI
import Cosmos

struct BookDetailsView: View {
    let audioBook: AudioBook
        @State private var rating: Double
        @State private var newRating: Double = 3.5
        @State private var expandedDescription: Bool = false
        @State private var showingMusicPlayer = false
        @State private var showingRatingDialog = false
        @State private var showingAlert = false
        @State private var alertMessage = ""
        @StateObject private var viewModel = AudioBookViewModel()
    init(audioBook: AudioBook) {
           self.audioBook = audioBook
           _rating = State(initialValue: audioBook.rating)
       
       }
    
    let categories: [(String, String)] = [
        ("Adventure", "http://localhost:8080/media/images/MattRockefeller.png1683522421785.png"),
        ("Fiction", "http://localhost:8080/media/images/OfaFeather.jpeg1683525106258.jpg"),
        ("Mystery", "http://localhost:8080/media/images/MattRockefeller.png1683522421785.png")
    ]

    var body: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                if let url = URL(string: audioBook.cover) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                        .blur(radius: 100)
                        .padding(.bottom, 450)
                }
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    if let url = URL(string: audioBook.cover) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 200, height: 260)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }

                    CosmosRatingView(rating: $rating)
                        .frame(height: 60)
                        .padding(.horizontal, 200)
                        .padding(.top)
                    
                    HStack(spacing: 20) {
                                       Button(action: {
                                           showingMusicPlayer = true
                                       }) {
                                           Image(systemName: "headphones")
                                               .foregroundColor(.white)
                                               .padding()
                                               .background(Color.yellow)
                                               .clipShape(Circle())
                                       }
                                       
                                       Button(action: {
                                           viewModel.addToBookShelf(bookId: audioBook.id) { error in
                                                  if let error = error {
                                                   
                                                      alertMessage = "Error adding book to favorites: \(error)"
                                                  } else {
                                                     
                                                      alertMessage = "Book successfully added to favorites"
                                                  }
                                                  showingAlert = true
                                              }
                                       }) {
                                           Image(systemName: "heart.fill")
                                               .foregroundColor(.white)
                                               .padding()
                                               .background(Color.yellow)
                                               .clipShape(Circle())
                                       }
                                       .alert(isPresented: $showingAlert) {
                                                   Alert(title: Text(alertMessage))
                                               }
                        Button(action: {
                                            showingRatingDialog = true
                                        }) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.yellow)
                                                .clipShape(Circle())
                                        }
                                   }

                    Divider()
                        .padding(.horizontal)

                    VStack(alignment: .center, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "person.fill")
                                    Text("Author: \(audioBook.author)")
                                }
                                .font(.headline)

                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("Duration: \(audioBook.duration)")
                                }
                                .font(.headline)
                            }

                            Divider()
                                .frame(height: 60)

                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "mic.fill")
                                    Text("Narrator: \(audioBook.narrator)")
                                }
                                .font(.headline)

                                HStack {
                                    Image(systemName: "globe")
                                    Text("Language: \(audioBook.language)")
                                }
                                .font(.headline)
                            }
                        }
                    }.padding(.horizontal,100)

                    Divider()
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.bottom)

                        Text(audioBook.description)
                            .font(.body)
                            .lineLimit(expandedDescription ? nil : 5)
                            .padding(.horizontal)
                            .padding(.bottom)
                          

                        if audioBook.description.count > 4 {
                            Button(action: {
                                expandedDescription.toggle()
                            }) {
                                HStack {
                                    Text("See more")
                                        .foregroundColor(.yellow)
                                        .font(.headline)

                                    Image(systemName: expandedDescription ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.yellow)
                                }
                            }.padding(.horizontal)
                                .padding(.bottom)
                        }
                        

                        

                        Text("Similar Books")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            

                       /* ScrollView(.horizontal, showsIndicators: false) {
                            CategoryBar(categories: [(audioBook.category, audioBook.cover)], booksByCategory: viewModel.booksByCategory)
                                                   .padding(.top, 10)
                           
                           
                        }
                       
                        .padding(.top)*/
                        if let similarBooks = viewModel.booksByCategory[audioBook.category] {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 30) {
                                    ForEach(similarBooks) { book in
                                        AudioBookCardView(audioBook: book)
                                    }
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal)
                        } else {
                            ProgressView()
                        }
                            
                    }  .padding(.horizontal,100)
                }
               
                
               
                
            }
        }
        .onAppear {
                  viewModel.fetchAudioBooksByCategory(category: audioBook.category)
              }
        .overlay(
                    RatingDialogView(isShowing: $showingRatingDialog, rating: $newRating) {
                        viewModel.updateBookRating(bookId: audioBook.id, newRating: newRating) { error in
                            if let error = error {
                                alertMessage = "Error updating book rating: \(error)"
                            } else {
                                alertMessage = "Book rating successfully updated"
                                rating = newRating
                            }
                            showingAlert = true
                        }
                    }
                )

      
        
        .sheet(isPresented: $showingMusicPlayer) {
            playedbook(book: audioBook)
        }
        
        
    }
}





struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        // Replace this with a sample audioBook for the preview
        let sampleAudioBook = AudioBook(id: "1", bookTitle: "Magalina", author: "Andy", cover: "http://localhost:8080/media/AudiobookCovers/MyCollections.png", category: "Mystery", description: "Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.\n Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.\n Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.\n Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.\n Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.", rating: 3, url: "url1", listened: 1000, date: "01/01/2022", duration: "35:00", narrator: "Salma", language: "English")
        BookDetailsView(audioBook: sampleAudioBook)
    }
}
