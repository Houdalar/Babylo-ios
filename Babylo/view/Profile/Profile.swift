//
//  Profile.swift
//  Babylo
//
//  Created by Babylo  on 16/4/2023.
//

import SwiftUI

struct Profile: View {
    @State private var baby: Baby?
    @StateObject private var babyViewModel = BabyViewModel()
    let token: String
    let babyName: String
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
            ZStack{
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    if let babyPic = baby?.babyPic, let url = URL(string: babyPic){
                        
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 200, height: 150)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.top)
                                    .frame(width: width, height: height / 2)
                                
                            case .failure:
                                Image("placeholder-image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.top)
                            @unknown default:
                                fatalError()
                            }
                        }
                    } else {
                        Image("placeholder-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.top)
                    }
                    DescriptionView( token: UserDefaults.standard.string(forKey: "token") ?? "",babyName: baby?.babyName ?? "Error", baby: $baby)
                        .offset(y: -60)
                    
                    
                }
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
    
    struct Profile_Previews: PreviewProvider {
        static var previews: some View {
            Profile(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: "Sample Baby")
        }
    }
    
    struct DescriptionView: View {
        @State var height = UIScreen.main.bounds.height
        @State var width = UIScreen.main.bounds.width
        @Binding private var baby: Baby?
        @StateObject private var babyViewModel = BabyViewModel()
        let token: String
        let babyName: String
        @State private var showHeightScreen = false
        @State private var showWeightScreen = false
        
        init(token: String, babyName: String, baby: Binding<Baby?>) {
            self.token = token
            self.babyName = babyName
            self._baby = baby
        }
        
        var body: some View {
            VStack(alignment: .center){
                Text("\(baby?.babyName ?? "Baby Name") ")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                HStack{
                    Spacer()
                    Text("\(baby?.birthday ?? ".. - .. - ...."), ").font(.subheadline)
                    Text("\(baby?.gender ?? "Gender")").font(.subheadline)
                    Spacer()
                }.padding(.top,1)
                
                Text("Growth parameters")
                    .font(.custom("CormorantGaramond-BoldItalic", size: 30))
                    .padding(.top, 30)
                    .padding(.trailing,160)
                
                HStack(spacing: 20){
                    Button(action: {
                        // Height action
                        showHeightScreen.toggle()
                    }) {
                        Text("Height")
                            .padding()
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showHeightScreen){
                        HeightView(babyViewModel: babyViewModel, babyName: babyName)
                    }
                    
                    Button(action: {
                        // Weight action
                        showWeightScreen.toggle()
                    }) {
                        Text("Weight")
                            .padding()
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showWeightScreen){
                        WeightView(babyViewModel: babyViewModel, babyName: babyName)
                    }
                    
                }
                Text("Medical parameters")
                    .font(.custom("CormorantGaramond-BoldItalic", size: 30))
                    .padding(.top, 20)
                    .padding(.trailing,160)
                
                HStack(spacing:30){
                    Button(action: {
                        // Doctor appointments action
                    }) {
                        Text("Doctor Appointments")
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Vaccines action
                    }) {
                        Text("Vaccines")
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            .padding()
            .background(.white)
            .padding(.top,1)
            .cornerRadius(45)
            //.frame(height: height * 0.2)
            Spacer()
        }
    }
}
