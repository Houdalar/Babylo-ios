//
//  HomeView.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var babyViewModel : BabyViewModel
    
    init(token: String) {
            _babyViewModel = StateObject(wrappedValue: BabyViewModel(token: token))
        }
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    TagLineView().padding()
        
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(babyViewModel.babies){
                                baby in BabyCardView(baby:baby,babyViewModel: babyViewModel)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.trailing)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarHidden(true)
        }.onAppear{
            babyViewModel.fetchBabies()
        }
    }
}

struct TagLineView: View {
    var body: some View {
        Text("Because every moment with your little one is ").font(.custom("DancingScript-Regular", size: 16))
            
            
        + Text("\nprecious !").font(.custom("DancingScript-Bold", size: 25))
            
            
    }
}

struct BabyCardView: View {
    let baby : Baby
 
   @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        NavigationLink(destination:
                        Profile(token: babyViewModel.token, babyName: baby.babyName)) {
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
                                .foregroundColor(.black)
            }
            .frame(width: 210)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
            .buttonStyle(PlainButtonStyle()) // This makes sure the entire card is clickable
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(token:UserDefaults.standard.string(forKey: "token") ?? "")
    }
}



