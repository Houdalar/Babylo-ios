//
//  BabyCardView.swift
//  Babylo
//
//  Created by Babylo  on 13/4/2023.
//

import SwiftUI

struct BabyCardView: View {
    let baby : Baby
    //@State private var showAlert = false
   @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        VStack {
            if let babyPic = baby.babyPic , let url = URL(string: babyPic){
                AsyncImage(url: url){
                    phase in
                    switch phase{
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 210)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 210)
                            .cornerRadius(20)
                    case .failure:
                        Image("placeholder-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 210)
                            .cornerRadius(20)
                    @unknown default:
                        fatalError()
                    }
                }
                                   
            }
            else{
                Image("placeholder-image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 210)
                                    .cornerRadius(20)

            }
            Text(baby.babyName)
                            .font(.title3)
                            .fontWeight(.bold)
        }
        .frame(width: 210)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
        .contextMenu{
            Button(action: {
                babyViewModel.deleteBaby(token: babyViewModel.token, babyName: baby.babyName) { result in
                    switch result {
                    case .success(let success):
                        if success {
                            print("Baby deleted")
                            babyViewModel.fetchBabies()
                        } else {
                            print("Failed to delete baby")
                        }
                    case .failure(let error):
                        print("Error deleting baby: \(error.localizedDescription)")
                    }
                }
            })
            {
                            Label("Delete Baby", systemImage: "trash")
                        }

        }
        
     
    }
}

struct BabyCardView_Previews: PreviewProvider {
    static var previews: some View {
        BabyCardView(baby: <#Baby#>, babyViewModel: <#BabyViewModel#>)
    }
}
