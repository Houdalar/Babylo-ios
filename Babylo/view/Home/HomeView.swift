//
//  HomeView.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU1OWU1NjFiZjlhNzhlNTNlMjQ5YyIsImlhdCI6MTY4MTIxODA2NX0.DVD3QYKhfTiHz_ftFV8lmXvgggUtuAHIdwGfLrZr8hw"
    
    @StateObject private var babyViewModel : BabyViewModel
    
    init(token: String) {
            _babyViewModel = StateObject(wrappedValue: BabyViewModel(token: token))
        }
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    /*HStack {
                        TextField("Search...", text: $searchText)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .frame(height: 40)
                            .background(Color.white)
                            .cornerRadius(20)
                        
                        Button(action: {
                            // Handle notifications
                        }) {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.yellow)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)*/
                    
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
        //.gesture(LongPressGesture(minimumDuration: 0.5).onEnded{_ in
           // showAlert = true
       // })
        //.alert(isPresented: $showAlert){
          //  Alert(
             //       title: Text("Delete Baby"),
             //       message: Text("Are you sure you want to remove \(baby.babyName)?"),
               //     primaryButton: .destructive(Text("Delete")) {
                //        babyViewModel.deleteBaby(token: babyViewModel.token, babyName: baby.babyName) { result in
                 //           switch result {
                  //          case .success(let success):
                  //              if success {
                  //                  print("Baby deleted")
                  //                  babyViewModel.fetchBabies()
                   //             } else {
                    //                print("Failed to delete baby")
                    //            }
                    //        case .failure(let error):
                     //           print("Error deleting baby: \(error.localizedDescription)")
                     //       }
                    //    }
                   // },
                 // secondaryButton: .cancel()
               // )
        //}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU1OWU1NjFiZjlhNzhlNTNlMjQ5YyIsImlhdCI6MTY4MTIxODA2NX0.DVD3QYKhfTiHz_ftFV8lmXvgggUtuAHIdwGfLrZr8hw")
    }
}



