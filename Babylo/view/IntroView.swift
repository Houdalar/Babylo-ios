//
//  IntroView.swift
//  Babylo
//
//  Created by Mac2021 on 13/3/2023.
//

import SwiftUI

struct IntroView: View {
    //MARK: Animation Proporties
    @State var showWalkThroughScreens: Bool = false
    @State var currentIndex : Int = 0
    @State var showSignupView : Bool = false
    @State var showLoginView : Bool = false
    var onFinish: () -> Void
    var body: some View {
        ZStack{
            if showSignupView{
                SignupView()
                    .transition(.move(edge: .trailing))
            }
            else if showLoginView{
                LoginView().transition(.move(edge: .trailing))
            }
            else{
                ZStack{
                    IntroScreen()
                    
                    WalkThroughScreens()
                    
                    NavBar()
                }
                .animation(.interactiveSpring(response: 1.1,dampingFraction: 0.85,blendDuration: 0.85),value: showWalkThroughScreens)
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSignupView)

    }
    

   //MARK: WalkThrough Screens
    @ViewBuilder
    func WalkThroughScreens()->some View{
        let isLast = currentIndex == intros.count
        
        GeometryReader{
            let size = $0.size
            
            ZStack{
                //MARK: Walk through Screens
                ForEach(intros.indices,id: \.self){
                    index in ScreenView(size: size, index: index)
                }
                WelcomeView(size: size, index: intros.count)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            //MARK: Next Button
            .overlay(alignment: .bottom){
                //MARK: Converting Next Button to Sign up button
                ZStack{
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .scaleEffect(!isLast ? 1 : 0.001)
                        .opacity(!isLast ? 1 : 0)
                    HStack{
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal,15)
                    .scaleEffect(isLast ? 1 : 0.001)
                    .frame(height: isLast ? nil : 0)
                    .opacity(isLast ? 1 : 0)
                    
                }

                .frame(width: isLast ? size.width / 1.5 : 55,height: isLast ? 50 : 55)
                .foregroundColor(.white)
                .background{
                    
                    RoundedRectangle(cornerRadius: isLast ? 10 : 30,style: isLast ? .continuous :  .circular)
                            .fill(AppColors.primary)
                    }
                    .onTapGesture {
                        if currentIndex == intros.count{
                            //Sign up
                            //showSignupView = true
                            //showLoginView=true
                            onFinish()
                        }
                        else{
                            //MARK: Updating Index
                            currentIndex += 1
                        }
                    }
                    .offset(y:isLast ? -40 : -90)
                //Animation
                    .animation(.interactiveSpring(response:0.9,dampingFraction: 0.8,blendDuration: 0.5 ), value: isLast)
            }
            .overlay(alignment: .bottom, content: {
                //MARK: Bottom Sign in Button
                let isLast = currentIndex == intros.count
                HStack(spacing: 5){
                    Text("Already have an account ?")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Button("Login"){
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primarydark)
                    
                }
                .offset(y:isLast ? -12 : 100)
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5), value: isLast)
            })
            .offset(y:showWalkThroughScreens ? 0 : size.height)
        }
    }
    
    @ViewBuilder
    func ScreenView(size : CGSize, index : Int)->some View{
        let intro = intros[index]
        
        VStack(spacing: 10){
            Text(intro.title)
                .fontWeight(.bold)
            //MARK: Applying offset fro each screen
                .offset(x: -size.width * CGFloat(currentIndex - index))
            //MARK: Adding Animation
            //MARK: Adding delay to Elements based on Index
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0 ).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text(dummyText)
                .multilineTextAlignment(.center)
                .padding(.horizontal,30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            Image(intro.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250,alignment: .top)
                .padding(.horizontal,20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2 ).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
        }
    }
    
    //MARK : Welcome Screen
    @ViewBuilder
    func WelcomeView(size : CGSize, index : Int)->some View{
        
        VStack(spacing: 10){
            Image("Baby")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250,alignment: .top)
                .padding(.horizontal,20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2 ).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            Text("Welcome")
                .fontWeight(.bold)
            //MARK: Applying offset fro each screen
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)

            
            Text("Description here description here description here description here description here description here description here description here description here description here")
                .multilineTextAlignment(.center)
                .padding(.horizontal,30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0 ).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)


        }
        .offset(y: -30)
    }
    
    
    //MARK: Nav Bar
    @ViewBuilder
    func NavBar()->some View{
        let isLast = currentIndex == intros.count
        HStack{
            Button {
                // if Greater than 0 then Eliminating index
                if currentIndex > 0 {
                    currentIndex -= 1
                }
                else{
                    showWalkThroughScreens.toggle()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            Spacer()
            Button("Skip"){
                currentIndex = intros.count
                
            }
            .font(.title3)
            .foregroundColor(.black)
            .opacity(isLast ? 0 : 1)
            .animation(.easeInOut, value: isLast)
        }
        .padding(.horizontal,15)
        .padding(.top,10)
        .frame(maxHeight: .infinity,alignment: .top)
        .offset(y:showWalkThroughScreens ? 0 : -120)
    }
    
    @ViewBuilder
    func IntroScreen()->some View{
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 15){
                Image("HappyBaby")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity,height: size.height / 2  ,alignment: .center)
                Text("Babylo")
                    .bold()
                    .padding(.top,40)
                  
                Text(dummyText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,50)
                   
                Text("Let's Begin")
                    .padding(.horizontal,45)
                    .padding(.vertical,18)
                    .foregroundColor(.white)
                    .background {
                        Capsule()
                    }
                    .onTapGesture {
                        showWalkThroughScreens.toggle()
                    }
                    .padding(.top,30)
            }
            .frame(width: .infinity,height: .infinity,alignment: .center)
            
            //MARK: Moving Up When Clicked
            .offset(y: showWalkThroughScreens ? -size.height : 0)
        }
       
    }
    
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

