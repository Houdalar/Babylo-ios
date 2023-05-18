import SwiftUI
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIImageColors
import SDWebImageSwiftUI

struct playedbook: View {

    let book : AudioBook
    @State private var isPlaying: Bool = false
    @State private var progressColor: Color = .green
    @State private var progress: Double = 0.8
    @State private var dominantColor: Color = .white
    @State private var currentPosition: String = "0:00"
    @State private var remainingTime: String = "-0:00"
    
    @StateObject private var audioPlayer = AudioPlayer()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack{
                            Button(action: {
                                // Back button tapped
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(Font.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Text("Now Playing")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(.label))
                            Spacer()
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 6, height: 6)
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 6, height: 6)
                                .padding(.trailing, 20)
                        }
            .padding(.bottom,50)
                       
            
            ZStack {
                           Circle()
                               .fill(Color.white)
                               .frame(width: 280, height: 280)
                          

                CDView(url: URL(string: book.cover)!)
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    .rotationEffect(Angle(degrees: isPlaying ? 360 : 0))
                    .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: isPlaying)
                    .shadow(radius: 10)
                    .padding(30)
                       }
                       .padding(.bottom, 20)

            Text(book.bookTitle)
                           .font(.custom("YourCustomFontName-ExtraBold", size: 24))
                           .foregroundColor(Color(.label))

            Text("by : "+book.author)
                           .font(.custom("YourCustomFontName-Regular", size: 18))
                           .foregroundColor(.gray)
                           .padding(.top, 20)
            Text("narrator : "+book.narrator)
                           .font(.custom("YourCustomFontName-Regular", size: 18))
                           .foregroundColor(.gray)
                           .padding(.top, 10)

            ProgressBar(value: $progress, progressColor: $progressColor, thumbPosition: CGFloat(progress))
                .frame(height: 8)
                .padding(.bottom, 10)
                

                       HStack {
                           Text(currentPosition)
                               .font(.caption)
                               .foregroundColor(.gray)

                           Spacer()

                           Text(remainingTime)
                               .font(.caption)
                               .foregroundColor(.gray)
                       }
            
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.isPlaying.toggle()
                    if isPlaying {
                           audioPlayer.play(url: book.url)
                       } else {
                           audioPlayer.pause()
                       }
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(progressColor)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 3)
                }
                
                Spacer()
                
            }
            .padding(.bottom, 20)
            
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 30)
        .background(
                    Color.white
                        .ignoresSafeArea()
                )
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                if let imageData = try? Data(contentsOf: URL(string: book.cover)!),
                   let image = UIImage(data: imageData),
                   let dominantColor = self.dominantColor(for: image) {
                    DispatchQueue.main.async {
                        progressColor = Color(dominantColor)
                    }
                }
            }
        }
        .onReceive(audioPlayer.$currentTime) { _ in
            updateTimeLabels()
            if audioPlayer.duration > 0 {
                progress = audioPlayer.currentTime / audioPlayer.duration
            }
        }
        .onDisappear {
            audioPlayer.pause()
            audioPlayer.currentTime = 0
        }
            }
    func dominantColor(for image: UIImage) -> UIColor? {
        if let colors = image.getColors() {
            return colors.primary
        }
        return nil
    }
    
    private func updateTimeLabels() {
        if !audioPlayer.currentTime.isNaN && !audioPlayer.currentTime.isInfinite && !audioPlayer.duration.isNaN && !audioPlayer.duration.isInfinite {
            let position = Int(audioPlayer.currentTime)
            let remaining = Int(audioPlayer.duration - audioPlayer.currentTime)
            currentPosition = String(format: "%d:%02d", position / 60, position % 60)
            remainingTime = String(format: "-%d:%02d", remaining / 60, remaining % 60)
        }
    }


 
        }
        

