//
//  NowPlaying.swift
//  Babylo
//
//  Created by houda lariani on 12/4/2023.
//

import SwiftUI
import AVFoundation
import CoreImage
import CoreImage.CIFilterShape



struct MusicPlayerView: View {
    let coverImage: Image
    let songName: String
    let artistName: String
    
    @State private var isPlaying: Bool = false
    @State private var progressColor: Color = .green
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 280, height: 280)
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(progressColor, lineWidth: 8)
                    .frame(width: 280, height: 280)
                    .rotationEffect(Angle(degrees: isPlaying ? 360 : 0))
                    .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: isPlaying)
                    .clipShape(Circle())
                CDView(image: coverImage)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    .rotationEffect(Angle(degrees: isPlaying ? 360 : 0))
                    .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: isPlaying)
                    .shadow(radius: 10)
                    .padding(30)
            }
            .padding(.bottom, 50)
            
            Text(songName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(.label))
            Text(artistName)
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                Button(action: {
                    // Previous button tapped
                }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    self.isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.white.opacity(0))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                }
                Spacer()
                Button(action: {
                    // Next button tapped
                }) {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            HStack(spacing: 50) {
                Button(action: {
                    // Heart button tapped
                }) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
                Button(action: {
                    // Add button tapped
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 30)
        .background(
            coverImage
                .resizable()
                .scaledToFill()
                .blur(radius: 30)
                .brightness(-0.1)
                .ignoresSafeArea()
        )
        
    }
    func dominantColor(for image: UIImage) -> UIColor? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // Apply a filter to extract the dominant color
        let params: [String: AnyObject] = [
            kCIInputImageKey: ciImage,
            "inputCubeDimension": 64 as AnyObject,

            "InputNormalizeVectorKey": [0.0, 0.0, 0.0] as AnyObject
        ]
        
        guard let colorCube = CIFilter(name: "CIColorCube", parameters: params),
              let outputImage = colorCube.outputImage else {
            return nil
        }
        
        // Render the filtered image
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        
        // Get the pixel data from the rendered image
        guard let data = cgImage?.dataProvider?.data,
              let buffer = CFDataGetBytePtr(data) else {
            return nil
        }
        
        // Compute the average color of the pixels
        let length = CFDataGetLength(data)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        for i in stride(from: 0, to: length, by: 4) {
            red += CGFloat(buffer[i]) / 255.0
            green += CGFloat(buffer[i+1]) / 255.0
            blue += CGFloat(buffer[i+2]) / 255.0
        }
        
        let count = CGFloat(length / 4)
        let color = UIColor(red: red/count, green: green/count, blue: blue/count, alpha: 1.0)
        
        return color
    }
    
}
struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
       
        MusicPlayerView(coverImage: Image("Mamafrog"), songName: "Example Song", artistName: "Example Artist")
    }
}

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    var style: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct CDView: View {
    let image: Image
    @State private var isRotating = false
    
    var body: some View {
        image
            .resizable()
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
            .mask(
                Circle()
                    .inset(by: 30)
                    .stroke(style: StrokeStyle(lineWidth: 150, lineCap: .round, lineJoin: .round))
                    .path(in: CGRect(x: 0, y: 0, width: 250, height: 250))
            )
            .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
            .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: isRotating)
            .onAppear {
                isRotating = true
            }
            .background(Color.clear)
    }
}


