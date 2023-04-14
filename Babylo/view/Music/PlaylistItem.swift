//
//  PlaylistItem.swift
//  Babylo
//
//  Created by houda lariani on 14/4/2023.
//

import SwiftUI
struct PlaylistCoverView: View {

    let playlist: Playlist

    

    var body: some View {

        ZStack(alignment: .bottomLeading) {

            AsyncImage(url: URL(string: playlist.cover)!) { image in

                image.resizable()

            } placeholder: {

                ProgressView()

            }

            .aspectRatio(contentMode: .fill)

            .frame(width: 280, height: 280)

            .cornerRadius(20)

           

            

            Text(playlist.name)

                .font(.system(size: 14, weight: .bold))

                .foregroundColor(.white)

                .padding(.horizontal, 10)

                .padding(.vertical, 5)

                .background(Color.black.opacity(0.5))

                .cornerRadius(19)

                .padding(.bottom, 10)

                .padding(.leading, 10)

        }

    }

}
