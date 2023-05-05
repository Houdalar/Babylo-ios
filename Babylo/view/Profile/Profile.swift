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
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    
    var body: some View {
            ZStack{
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    ZStack(alignment:.topTrailing){
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
                        
                       
                        ZStack {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {}
                                
                                Image(systemName: "pencil")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                                    .padding(.leading , 350)
                                    .padding(.bottom, 350)
                                    .zIndex(1) // Make sure the pencil image is on top
                                    .onTapGesture {
                                        print("Button tapped")
                                        isImagePickerPresented.toggle()
                                    }
                            }
        
                    }
                    DescriptionView( token: UserDefaults.standard.string(forKey: "token") ?? "",babyName: baby?.babyName ?? "Error", baby: $baby)
                        .offset(y: -60)
                    
                    
                }
            }
            .sheet(isPresented: $isImagePickerPresented, onDismiss: {
                                    if let selectedImage = selectedImage {
                                        babyViewModel.updateBaby(token: token, babyName: babyName, image: selectedImage) { result in
                                            switch result {
                                            case .success(let message):
                                                print(message)
                                                // Reload the baby data to reflect the updated image
                                                babyViewModel.getBaby(token: token, babyName: babyName) { result in
                                                    switch result {
                                                    case .success(let fetchedBaby):
                                                        baby = fetchedBaby
                                                    case .failure(let error):
                                                        print("Error fetching baby: \(error.localizedDescription)")
                                                    }
                                                }
                                            case .failure(let error):
                                                print("Error updating baby photo: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }) {
                                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
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
        @State private var showVaccineScreen = false
        @State private var showDoctorScreen = false
        
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
                    if let gender = baby?.gender {
                        if gender == "Boy" {
                            Text("\(baby?.birthday ?? ".. - .. - ...."), ").font(.callout)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                        }
                        else if gender == "Girl" {
                            Text("\(baby?.birthday ?? ".. - .. - ...."), ").font(.callout)
                                .foregroundColor(.pink)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    if let gender = baby?.gender {
                        if gender == "Boy" {
                            Image("male")
                                .resizable()
                                .frame(width: 30, height: 30)
                        } else if gender == "Girl" {
                            Image("female")
                                .resizable()
                                .frame(width: 30, height: 32)
                        }
                    }
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
                        showDoctorScreen.toggle()
                    }) {
                        Text("Doctor Appointments")
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showDoctorScreen){
                        AppointmentsView(babyViewModel: babyViewModel, babyName: babyName)
                    }
                    
                    Button(action: {
                        // Vaccines action
                        showVaccineScreen.toggle()
                    }) {
                        Text("Vaccines")
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showVaccineScreen){
                        VaccineView(babyViewModel: babyViewModel, babyName: babyName)
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
