//
//  songItem.swift
//  Babylo
//
//  Created by houda lariani on 14/4/2023.
//

import SwiftUI
import Kingfisher

// track item 
struct TrackRow: View {
    let track: Track
    let isPlaylistSong: Bool
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: track.cover)!) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(track.name)
                    .font(.headline)
                Text(track.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading)
            Spacer()
            Text(track.duration)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.trailing)
            Button(action: {
                // Action for the three-dot button
                if isPlaylistSong {
                    // Show option to remove the song from the playlist
                } else {
                    // Show option to add the song to a playlist
                }

            }) {
                VStack(spacing: 2) {
                    Circle().frame(width: 3, height: 3).foregroundColor(Color.gray)
                    Circle().frame(width: 3, height: 3).foregroundColor(Color.gray)
                    Circle().frame(width: 3, height: 3).foregroundColor(Color.gray)
                }
            }
        }
    }
}

// new tracks
struct TrackCardView: View {
    var track: Track
    var trendingLabelOpacity: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
            
            VStack {
                ZStack(alignment: .bottomLeading) {
                    KFImage(URL(string: track.cover))
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 250) // Add this line
                        .clipped()
                        .cornerRadius(20)
                    
                    Text(track.name)
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
    }
}

// trending
struct SmallTrackCardView: View {
    var track: Track
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                
                KFImage(URL(string: track.cover))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(20)
            }
            .frame(width: 100, height: 100)
            
            Text(track.name)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .padding(.top, 5)

            Text(track.artist)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

// albums
struct AlbumCardView: View {
    var playlist: Albums

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 30) // RoundedRectangle for rounded edges
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 160, height: 160)

                KFImage(URL(string: playlist.cover))
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Change this to .fill
                    .frame(width: 160, height: 160) // Update the width and height
                    .cornerRadius(20)
                    .clipped() // Add this to clip the image to the corner radius

                Text(playlist.name) // Display the album name as the category label
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.brown.opacity(0.8)) // Use a darker color
                    .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                    .background(Color.white) // Set background color to white
                    .cornerRadius(30)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0)) // Add padding to create spacing
            }
        }
    }
}
