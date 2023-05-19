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
    
    @State private var upcomingVaccines: [UpcomingVaccine] = []
    @State private var notificationScheduled : Bool = false
    
    @State private var selectedBaby: Baby?
    

    func stringToDate(_ dateString: String, format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateString)
    }
   

    func scheduleNotification(for vaccine: UpcomingVaccine) {
        print ("Scheduling notification for vaccine: \(vaccine.vaccine)")

        let notificationIdentifier = "vaccine-\(vaccine.id)"

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let existingRequest = requests.first { $0.identifier == notificationIdentifier }

            if existingRequest == nil {
                // Schedule the notification only if it doesn't exist
                let content = UNMutableNotificationContent()
                content.body = "Reminder 📣:\nYou're doing an amazing job as a parent! Keep up the great work by bringing your baby in for their vaccine appointment tomorrow 💉"

                content.sound = .default

                let dateString = vaccine.date
                if let date = stringToDate(dateString) {
                    //let triggerDate = Calendar.current.date(byAdding: .second, value: 3, to: Date())!
                     let triggerDate = Calendar.current.date(byAdding: .hour, value: -24, to: date)!
                    let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                    let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Failed to schedule notification: \(error.localizedDescription)")
                        } else {
                            print("Notification scheduled for vaccine \(vaccine.vaccine) 3 seconds from now.")
                        }
                    }
                }
            } else {
                print("Notification for vaccine \(vaccine.vaccine) is already scheduled.")
            }
        }
    }
    

    
    init(token: String) {
            _babyViewModel = StateObject(wrappedValue: BabyViewModel(token: token))
        }
    
    var body: some View {
        NavigationView {
        VStack(spacing:0){
            GeometryReader { geometry in
                HStack{
                    Spacer()
                    
                }
                
                .padding(.top,geometry.safeAreaInsets.top + 90)
                .padding(.bottom,50)
                .background(Color.yellow)
                .clipShape(Corners(corner: .bottomRight, size: CGSize(width: 60, height: 56)))
                
                HStack{
                    VStack{
                        HStack{
                            Spacer()
                            
                            Image("mom_and_son")
                                .resizable()
                                .frame(width: 130,height: 130)
                                .offset(x:8, y: -9)
                        }
                        
                        HStack{
                            VStack(alignment:.leading){
                                Text("Because every moment  ").font(.custom("DancingScript-Regular", size: 21))
                                + Text("\nwith your little one is").font(.custom("DancingScript-Regular", size: 26))
                                    
                                + Text("\nprecious !").font(.custom("DancingScript-SemiBold", size: 40))
                            }
                        }
                        .padding(.top,-50)
                        .padding(.trailing,36)
                        
                    }
                    .padding(.bottom,20)
                    .frame(width: UIScreen.main.bounds.width - 130)
                    .background(AppColors.lighter)
                    .clipShape(Corners(corner: [.topLeft,.topRight,.bottomRight], size: CGSize(width: 60, height: 60)))
                    
                    Spacer()

                }
                .padding(.top,88)
                
                ZStack{
                    //Color.white
                    //AppColors.lighter
                    (upcomingVaccines.count <= 1 ? Color.white : AppColors.lighter)

                    
                    ScrollView{
                        VStack{
                            
                            HStack{
                                Text("Upcoming Vaccines")
                                    .font(.custom("CormorantGaramond-BoldItalic", size: 30))
                                
                                
                                Spacer()
                            }
                            .padding(.leading,35)
                            .padding(.top,30)
                            
                            ForEach(upcomingVaccines) { vaccine in
                                UpcomingVaccineCard(upcomingVaccine: vaccine)
                            }

                            
                            HStack{
                                Text("My precious ones")
                                    .font(.custom("CormorantGaramond-BoldItalic", size: 30))
                                
                                
                                
                                Spacer()
                            }
                            .padding(.leading,35)
                            .padding(.top)
                            
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing: 25){
                                    ForEach(babyViewModel.babies){
                                        baby in BabyCardView(baby:baby, babyViewModel: babyViewModel)
                                    }
                                    AddBabyCard()
                                }.padding(.leading,22)
                                Spacer()
                            }
                            .padding(.top,8)
                            
                            Spacer()

                        }
                        .background(Color.white)
                        .clipShape(Corners(corner: .topLeft, size: CGSize(width: 70, height: 70)))
                    }
                    
                }
                .offset(y: height * 0.322)
                
                
                
            }
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
            if let baby = selectedBaby {
                        NavigationLink(destination: Profile(token: babyViewModel.token, babyName: baby.babyName),
                                       isActive: .constant(selectedBaby != nil),
                                       label: { EmptyView() })
                    }
        }
        .onAppear{
            babyViewModel.fetchBabies()
            if !notificationScheduled {
                    babyViewModel.getUpcomingVaccines(token: UserDefaults.standard.string(forKey: "token") ?? "") { result in
                        switch result {
                        case .success(let vaccines):
                            upcomingVaccines = vaccines
                            print("Upcoming vaccines: \(upcomingVaccines)")
                            for vaccine in vaccines {
                                scheduleNotification(for: vaccine)
                            }
                            notificationScheduled = true
                        case .failure(let error):
                            print("Error loading upcoming vaccines: \(error.localizedDescription)")
                        }
                    }
                }
            

        }
      
        
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
        NavigationLink(destination: Profile(token: babyViewModel.token, babyName: baby.babyName)) {
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
                    .font(.custom("CormorantGaramond-BoldItalic", size: 15))
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

struct BabyCardView: View {
    let baby : Baby

    @ObservedObject var babyViewModel: BabyViewModel
    @State var isLinkActive = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let babyPic = baby.babyPic , let url = URL(string: babyPic) {
                AsyncImage(url: url) {
                    phase in
                    switch phase{
                    case .empty:
                        ProgressView()
                            .frame(width: 280, height: 280)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 280, height: 280)
                            .cornerRadius(20)
                    case .failure:
                        Image("placeholder-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 280, height: 280)
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
                    .frame(width: 280, height: 280)
                    .cornerRadius(20)
            }

            Text(baby.babyName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.5))
                .cornerRadius(19)
                .padding(.bottom, 10)
                .padding(.leading, 10)

            NavigationLink(
                destination: Profile(token: babyViewModel.token, babyName: baby.babyName),
                isActive: $isLinkActive,
                label: { EmptyView() }
            )
        }
        .onTapGesture {
            isLinkActive = true
        }
        .frame(width: 280, height: 280)
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



struct AddBabyCard: View {
    var token: String {
        UserDefaults.standard.string(forKey: "token") ?? ""
    }
    let babyViewModel = BabyViewModel()
    
    var body: some View {
        NavigationLink(destination: AddBaby(token: token).environmentObject(babyViewModel)) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray5))
                    .frame(width: 280, height: 280)

                Image(systemName: "plus")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
