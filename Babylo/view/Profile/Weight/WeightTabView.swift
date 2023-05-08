//
//  WeightTabView.swift
//  Babylo
//
//  Created by Babylo  on 26/4/2023.
//


import SwiftUI

struct WeightTabView: View {
    @ObservedObject var babyViewModel: BabyViewModel
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var showAddWeightModal = false
    @State private var weightIndexToDelete: Int?
    let babyName: String

    private var addButton: some View {
        Button(action: {
            showAddWeightModal = true
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
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let weightToDelete = babyViewModel.weights[index]
            showAlert = true
            weightIndexToDelete = index
        }
    }

    

       private func confirmDelete() {
           guard let index = weightIndexToDelete else { return }
           let weightToDelete = babyViewModel.weights[index]
           babyViewModel.deleteWeight(token: UserDefaults.standard.string(forKey: "token") ?? "", date: weightToDelete.date, babyName: babyName) { result in
               switch result {
               case .success(_):
                   DispatchQueue.main.async {
                       babyViewModel.weights.removeAll { weight in
                           weight.id == weightToDelete.id
                       }
                   }
               case .failure(let error):
                   DispatchQueue.main.async {
                       errorMessage = error.localizedDescription
                   }
               }
           }
           showAlert = false
       }
    
    var body: some View {
        NavigationView {
            List {
                        ForEach(babyViewModel.weights) { weight in
                            WeightCard(weight: weight)
                        }
                        .onDelete(perform: delete)
                    }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Weight"), message: Text("Are you sure you want to remove this weight?"), primaryButton: .destructive(Text("Delete")) {
                confirmDelete()
            }, secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: addButton)
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
            babyViewModel.getBabyWeights(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: babyName) { result in
                switch result {
                case .success(_):
                    // Data is loaded successfully
                    print("Weights loaded successfully.")
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .overlay(showAddWeightModal ? CustomWeightDialog(isPresented: $showAddWeightModal, addWeight: { weight,date in
            babyViewModel.addWeight(token: UserDefaults.standard.string(forKey: "token") ?? "", weight: weight, babyName: babyName,date: date) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weight):
                        if !babyViewModel.weights.contains(where: { $0.id == weight.id }) {
                                            babyViewModel.weights.append(weight)
                                        }
                                        showAddWeightModal = false
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }) : nil)

    }

}

struct WeightCard: View {
    let weight: Weight
    //var onDelete: ((Height) -> Void)?
    @State private var offset: CGFloat = 0
   
    var body: some View {
        HStack {
            Text(weight.weight)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.leading)
            
            Text("Kg")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
           
            Spacer()
           
            Text(weight.date)
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

struct CustomWeightDialog: View {
    @Binding var isPresented: Bool
    @State private var weight: String = ""
    @State private var date: Date = Date()

    var addWeight: (_ weight: String, _ date: String) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                VStack (spacing: 20){
                    Text("Add Weight")
                        .font(.headline)
                        .padding()

                    TextField("Enter weight (Kg)", text: $weight)
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
                            addWeight(weight,dateString)
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




struct WeightTabView_Previews: PreviewProvider {
    static var previews: some View {
        let babyViewModel = BabyViewModel()
        babyViewModel.weights = [
            Weight(weight: "3", babyId: "1", date: "2023-04-25"),
            Weight(weight: "3.5", babyId: "1", date: "2023-05-10")
        ]
        return WeightTabView(babyViewModel: babyViewModel, babyName: "Sample Baby")
    }
}

