import SwiftUI
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIImageColors
import SDWebImageSwiftUI

struct MusicPlayerView: View {

    let track : Track
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
                               .frame(width: 300, height: 300)
                          

                CDView(url: URL(string: track.cover)!)
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    .rotationEffect(Angle(degrees: isPlaying ? 360 : 0))
                    .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: isPlaying)
                    .shadow(radius: 10)
                    .padding(30)
                       }
                       .padding(.bottom, 20)

            Text(track.name)
                           .font(.custom("YourCustomFontName-ExtraBold", size: 30))
                           .foregroundColor(progressColor)
                           .fontWeight(.bold)
                           

            Text(track.artist)
                           .font(.custom("YourCustomFontName-Regular", size: 18))
                           .foregroundColor(.gray)
                           .padding(.top,10)
                           .padding(.bottom, 20)

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
                Button(action: {
                    // Previous button tapped
                }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    self.isPlaying.toggle()
                    if isPlaying {
                           audioPlayer.play(url: track.url)
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
                
                Button(action: {
                    // Next button tapped
                }) {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                
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
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: URL(string: track.cover)!),
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

struct MusicPlayerView_Previews: PreviewProvider {
            static var previews: some View {
                MusicPlayerView(track: Track(id: "1", name: "morning", artist: "houda", cover: "http://localhost:8080/media/images/Italian_Illustrator_Shows_The_True_Colors_Of_Cats_That_Prove_How_Adorable_They_Can_Be_(30_Pics).png1682507562100.png", category: "String", url: "http://localhost:8080/media/audiobooks/aladdin.mp3", listened: 4, date: "String", duration: "String"))
            }
        }

struct ProgressBar: View {
        @Binding var value: Double
            var progressColor: Binding<Color>
            var thumbPosition: CGFloat

        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    Rectangle()
                        .foregroundColor(progressColor.wrappedValue)
                        .frame(width: CGFloat(self.value) * geometry.size.width)
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(progressColor.wrappedValue)
                        .position(x: thumbPosition * geometry.size.width, y: geometry.size.height / 2)
                }
                .cornerRadius(4)
            }
        }
    }

struct CDView: View {
        let url: URL
        @State private var isRotating = false

        var body: some View {
            WebImage(url: url)
                .resizable()
                .frame(width: 400, height: 400)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 5))
                .mask(
                    Circle()
                        .inset(by: 30)
                        .stroke(style: StrokeStyle(lineWidth: 275, lineCap: .round, lineJoin: .round))
                        .path(in: CGRect(x: 0, y: 0, width: 400, height: 400))
                )
                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: isRotating)
                .onAppear {
                    isRotating = true
                }
                .background(Color.clear)
        }
    }
struct BlurryBackgroundView: View {
    var color: Color

    var body: some View {
        Rectangle()
            .fill(color)
            .blur(radius: 30)
            .edgesIgnoringSafeArea(.all)
    }
}

class AudioPlayer: ObservableObject {
    @Published var player: AVPlayer
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    var timeObserver: Any?
    var seekTime: CMTime?

    init() {
        player = AVPlayer()
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) { [weak self] time in
            guard let currentItem = self?.player.currentItem else { return }
            self?.currentTime = time.seconds
            self?.duration = currentItem.duration.seconds
        }
    }
    
    func play(url: String) {
            if let audioURL = URL(string: url) {
                let playerItem = AVPlayerItem(url: audioURL)
                player.replaceCurrentItem(with: playerItem)
                
                if let seekTime = seekTime {
                    player.seek(to: seekTime)
                }
                
                player.play()
            }
        }
    
    func pause() {
            seekTime = player.currentTime()
            player.pause()
        }
}
