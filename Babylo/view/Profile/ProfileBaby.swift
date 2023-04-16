//
//  ProfileBaby.swift
//  Babylo
//
//  Created by Babylo  on 15/4/2023.
//
import SwiftUI

struct ProfileBaby: View {
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    @State private var baby: Baby?
    @StateObject private var babyViewModel = BabyViewModel()
    let token: String
    let babyName: String
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                GeometryReader { geometry in
                    if let babyPic = baby?.babyPic, let url = URL(string: babyPic) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                            case .failure:
                                Image("placeholder-image")
                                    .resizable()
                            @unknown default:
                                fatalError()
                            }
                        }
                    } else {
                        Image("placeholder-image")
                            .resizable()
                    }
                }
                .frame(width: width, height: height / 3 + 15)
                .mask(CustomShape(corner: .bottomLeft, radii: 55))
                .shadow(radius: 5)
                .padding(.bottom, 50)
                .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
                
                Text("\(baby?.babyName ?? "Baby Name"), ")
                    .font(.title)
                
                + Text("\(baby?.gender ?? "Gender")")
                    .font(.subheadline)
                
                Text("\(baby?.birthday ?? ".. - .. - ....")")
                    .font(.body)
                Text("Growth parameters")
                    .font(.title2)
                    .padding(.top, 20)
                
                Spacer(minLength: 0)
            }
            .edgesIgnoringSafeArea(.all)
            .statusBarHidden(true)
        }
        .onAppear {
            babyViewModel.getBaby(token: token, babyName: babyName) { result in
                switch result {
                case .success(let fetchedBaby):
                    baby = fetchedBaby
                case .failure(let error):
                    print("Error fetching baby: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ProfileBaby_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBaby(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: "Sample Baby")
    }
}

struct CustomShape : Shape {
    var corner : UIRectCorner
    var radii : CGFloat
    
    func path (in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        return Path(path.cgPath)
    }
}

