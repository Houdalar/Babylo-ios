//
//  HeightTabView.swift
//  Babylo
//
//  Created by Babylo  on 25/4/2023.
//

import SwiftUI

struct HeightTabView: View {
    @ObservedObject var babyViewModel: BabyViewModel
    @State private var errorMessage: String?
    @State private var showAddHeightModal = false
    let babyName: String

    private var addButton: some View {
        Button(action: {
            showAddHeightModal = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24,weight: .bold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.yellow)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
        }
    }


    var body: some View {
        ScrollView {
            VStack {
                ForEach(babyViewModel.heights) { height in
                    HeightCard(height: height.height, date: height.date).id(height.id)
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    addButton
                }
            }
                .padding(.trailing,30)
                .padding(.bottom)
        )
        .onAppear {
            babyViewModel.getBabyHeights(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: babyName) { result in
                switch result {
                case .success(_):
                    // Data is loaded successfully
                    print("Heights loaded successfully.")
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .overlay(showAddHeightModal ? CustomDialog(isPresented: $showAddHeightModal, addHeight: { height,date in
            babyViewModel.addHeight(token: UserDefaults.standard.string(forKey: "token") ?? "", height: height, babyName: babyName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let height):
                        if !babyViewModel.heights.contains(where: { $0.id == height.id }) {
                                            babyViewModel.heights.append(height)
                                        }
                                        showAddHeightModal = false
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }) : nil)

    }

}

struct HeightCard: View {
    let height: String
    let date: String
   
    var body: some View {
        HStack {
            Text(height)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.leading)
            
            Text("cm")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
           
            Spacer()
           
            Text(date)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding(.trailing)
        }
        .padding()
        .background(AppColors.moreLighter)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct CustomDialog: View {
    @Binding var isPresented: Bool
    @State private var height: String = ""
    @State private var date: Date = Date()

    var addHeight: (_ height: String, _ date: String) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                VStack (spacing: 20){
                    Text("Add Height")
                        .font(.headline)
                        .padding()

                    TextField("Enter height (cm)", text: $height)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)

                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                                     .padding()
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .padding()
                        .foregroundColor(.red)

                        Button("Save") {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            let dateString = dateFormatter.string(from: date)
                            addHeight(height,dateString)
                            //isPresented = false
                        }
                        .padding()
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        
                    }
                    .padding(.bottom)
                 
                }
                .frame(width:300)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            .shadow(radius: 10)
            }
        }
    }
}


struct HeightTabView_Previews: PreviewProvider {
    static var previews: some View {
        let babyViewModel = BabyViewModel()
        babyViewModel.heights = [
            Height( height: "70", babyId: "1", date: "2023-04-25"),
            Height(height: "75", babyId: "1", date: "2023-05-10")
        ]
        return HeightTabView(babyViewModel: babyViewModel, babyName: "Sample Baby")
    }
}

