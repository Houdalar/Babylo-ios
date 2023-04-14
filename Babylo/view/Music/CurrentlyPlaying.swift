//
//  CurrentlyPlaying.swift
//  Babylo
//
//  Created by houda lariani on 14/4/2023.
//

import SwiftUI

struct CurrentlyPlayingView: View {

    let track: Track



    var body: some View {

        VStack {

            Spacer()



            HStack {

                AsyncImage(url: URL(string: track.cover)!) { image in

                    image.resizable()

                } placeholder: {

                    ProgressView()

                }

                .frame(width: 50, height: 50)

                .cornerRadius(20)

                .padding(.leading,10)



                VStack(alignment: .leading) {

                    Text(track.name)

                        .font(.headline)

                        .foregroundColor(.white)

                    Text(track.artist)

                        .font(.subheadline)

                        .foregroundColor(.white)

                }



                Spacer()



                Button(action: {

                    // Action for the play/pause button

                }) {

                    Image(systemName: "play.fill")

                        .resizable()

                        .frame(width: 20, height: 20)

                        .foregroundColor(.white)

                }

                .padding(.trailing)

                

            }

            .padding()

            .background(

                AsyncImage(url: URL(string: track.cover)!) { image in

                    image

                        .resizable()

                        .aspectRatio(contentMode: .fill)

                        .frame(width: UIScreen.main.bounds.width)

                } placeholder: {

                    ProgressView()

                }

                .blur(radius: 15)

                .overlay(Color.black.opacity(0.4))

                

            )

            .cornerRadius(40)

            .padding(.horizontal)

        }

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

    }

}
