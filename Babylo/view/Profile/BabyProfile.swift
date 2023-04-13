//
//  BabyProfile.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//
import SwiftUI

struct BabyProfile: View {
    @State private var baby: Baby?
    @StateObject private var babyViewModel = BabyViewModel()
    let token: String
    let babyName: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                VStack {
                    if let babyPic = baby?.babyPic, let url = URL(string: babyPic){
                
                        AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .frame(width: 200, height: 150)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 200, height: 150)
                                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                                            .shadow(radius: 5)
                                                            .padding(.bottom, 50)
                                                    case .failure:
                                                        Image("placeholder-image")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 200, height: 150)
                                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                                            .shadow(radius: 5)
                                                            .padding(.bottom, 50)
                                                    @unknown default:
                                                        fatalError()
                                                    }
                                                }
                                            } else {
                                                Image("placeholder-image")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 200, height: 150)
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                    .shadow(radius: 5)
                                                    .padding(.bottom, 50)
                                            }
                    
                    Text("\(baby?.babyName ?? "Baby Name"), ")
                                            .font(.title)

                                        + Text("\(baby?.gender ?? "Gender")")
                                            .font(.subheadline)
                }
                .padding(.top, 60)
                
                //Text("Birthday: \(baby.birthday)")
                Text("\(baby?.birthday ?? ".. - .. - ....")")
                    .font(.body)
                Text("Growth parameters")
                    .font(.title2)
                    .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            // Height action
                        }) {
                            Text("Height")
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Weight action
                        }) {
                            Text("Weight")
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                
                Text("Medical Appointments")
                    .font(.title2)
                    .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Button(action: {
                            // Doctor appointments action
                        }) {
                            Text("Doctor Appointments")
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Vaccines action
                        }) {
                            Text("Vaccines")
                                .padding()
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onAppear{
            babyViewModel.getBaby(token: token, babyName: babyName){ result in
                switch result {
                case .success(let fetchedBaby):
                    baby = fetchedBaby
                case .failure(let error):
                    print("Error fetching baby: \(error.localizedDescription)")
                }
            }
        }
    }
    
    struct BabyProfile_Previews: PreviewProvider {
        static var previews: some View {
            BabyProfile(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: "Sample Baby")
        }
    }
}

