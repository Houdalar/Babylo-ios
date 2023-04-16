//
//  HomeScreen.swift
//  Babylo
//
//  Created by Babylo  on 15/4/2023.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @StateObject private var babyViewModel : BabyViewModel
    
    init(token: String) {
            _babyViewModel = StateObject(wrappedValue: BabyViewModel(token: token))
        }
    
    var body: some View {
        VStack(spacing:0){
            GeometryReader { geometry in
                HStack{
                    
                    Spacer()
                    
                    
                }
                
                .padding(.top,geometry.safeAreaInsets.top + 90)
                .padding(.bottom,75)
                .background(Color.yellow)
                .clipShape(Corners(corner: .bottomRight, size: CGSize(width: 56, height: 56)))
                
                HStack{
                    VStack{
                        HStack{
                            Spacer()
                            
                            Image("pic")
                                .resizable()
                                .frame(width: 150,height: 125)
                                .offset(y: 0.26)
                        }
                        
                        HStack{
                            VStack(alignment:.leading){
                                Text("Because every moment with ").font(.custom("DancingScript-Regular", size: 25))
                                + Text("\nyour little one is").font(.custom("DancingScript-Regular", size: 30))
                                    
                                + Text("\nprecious !").font(.custom("DancingScript-SemiBold", size: 48))
                            }
                        }
                        .padding(.top,-20)
                        .padding(.trailing,32)
                        
                    }
                    .padding(.bottom,70)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(AppColors.lighter)
                    .clipShape(Corners(corner: [.topLeft,.topRight,.bottomRight], size: CGSize(width: 70, height: 70)))
                    
                    Spacer()

                }
                .padding(.top,100)
                
                ZStack{
                    AppColors.lighter
                    
                    VStack{
                        HStack{
                            Text("My precious ones")
                                .font(.custom("CormorantGaramond-BoldItalic", size: 35))
                                
                                
                                
                            Spacer()
                        }
                        .padding(.leading,35)
                        .padding(.top,25)
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing: 25){
                                ForEach(babyViewModel.babies){
                                    baby in BabyCardView(baby:baby,babyViewModel: babyViewModel)
                                }
                            }.padding(.leading,22)
                        Spacer()
                        }
                        .padding(.top,8)
                        
                        Spacer()
                    }
                    .background(Color.white)
                    .clipShape(Corners(corner: .topLeft, size: CGSize(width: 70, height: 70)))
                }
                .offset(y: height * 0.435)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
            
        }
        .onAppear{
            babyViewModel.fetchBabies()
        }
    }
}

struct Corners : Shape {
    
    var corner : UIRectCorner
    var size : CGSize
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: size)
        
        return Path(path.cgPath)
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(token:UserDefaults.standard.string(forKey: "token") ?? "")
    }
}

struct CardView : View {
    let baby : Baby
 
   @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        NavigationLink(destination:ProfileBaby(token: babyViewModel.token, babyName: baby.babyName)) {
            VStack {
                if let babyPic = baby.babyPic , let url = URL(string: babyPic){
                    AsyncImage(url: url){
                        phase in
                        switch phase{
                        case .empty:
                            ProgressView()
                                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 5)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 5)
                                .cornerRadius(35)
                        case .failure:
                            Image("placeholder-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 5)
                                .cornerRadius(35)
                        @unknown default:
                            fatalError()
                        }
                    }
                                       
                }
                else{
                    Image("placeholder-image")
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 5)
                                        .cornerRadius(35)

                }
                Text(baby.babyName)
               
                    .font(.custom("CormorantGaramond-BoldItalic", size: 35))
                                .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width / 2)
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(35)
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
            .buttonStyle(PlainButtonStyle()) // This makes sure the entire card is clickable
            .contextMenu{
                Button(action: {
                    babyViewModel.deleteBaby(token: babyViewModel.token, babyName: baby.babyName) { result in
                        switch result {
                        case .success(let success):
                            if success {
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

