//
//  VaccineView.swift
//  Babylo
//
//  Created by Babylo  on 4/5/2023.
//

import SwiftUI

struct VaccineView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var babyViewModel: BabyViewModel
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var showAddVaccineModel = false
    @State private var VaccineIndexToDelete: Int?
    let babyName: String

    private var addButton: some View {
        Button(action: {
            showAddVaccineModel = true
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
            let vaccineToDelete = babyViewModel.vaccines[index]
            showAlert = true
            VaccineIndexToDelete = index
        }
    }

    

       private func confirmDelete() {
           guard let index = VaccineIndexToDelete else { return }
           let vaccineToDelete = babyViewModel.vaccines[index]
           babyViewModel.deleteVaccine(token: UserDefaults.standard.string(forKey: "token") ?? "", date: vaccineToDelete.date, babyName: babyName, vaccine: vaccineToDelete.vaccine) { result in
               switch result {
               case .success(_):
                   DispatchQueue.main.async {
                       babyViewModel.vaccines.removeAll { vaccine in
                           vaccine.id == vaccineToDelete.id
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
        VStack{
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }.foregroundColor(.black)
                    .padding()
                
                Spacer()
            }
            List {
                        ForEach(babyViewModel.vaccines) { vaccine in
                            VaccineCard(vaccine: vaccine)
                        }
                        .onDelete(perform: delete)
                    }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Vaccine"), message: Text("Are you sure you want to remove this vaccine ?"), primaryButton: .destructive(Text("Delete")) {
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
            babyViewModel.getVaccines(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: babyName) { result in
                switch result {
                case .success(_):
                    print("Vaccines loaded successfully.")
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .overlay(showAddVaccineModel ? CustomVaccineDialog(isPresented: $showAddVaccineModel, addVaccine: { vaccine,date in
            babyViewModel.addVaccine(token: UserDefaults.standard.string(forKey: "token") ?? "", vaccine: vaccine, date: date, babyName: babyName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let vaccine):
                        if !babyViewModel.vaccines.contains(where: { $0.id == vaccine.id }) {
                                            babyViewModel.vaccines.append(vaccine)
                                        }
                                        showAddVaccineModel = false
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }) : nil)
        
    }
    
    struct VaccineView_Previews: PreviewProvider {
        
        static var previews: some View {
            let babyViewModel = BabyViewModel()
            babyViewModel.vaccines = [
                Vaccine( vaccine: "Vaccine name", babyId: "1", date: "2023-05-25"),
                Vaccine(vaccine: "Vaccine name", babyId: "1", date: "2023-08-10")
            ]
           return VaccineView(babyViewModel: babyViewModel, babyName: "Sample Name")
        }
    }
}

struct VaccineCard: View {
    let vaccine: Vaccine
    @State private var offset: CGFloat = 0
   
    var body: some View {
        HStack {
            Text(vaccine.vaccine)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.leading)
            
           
            Spacer()
           
            Text(vaccine.date)
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

struct CustomVaccineDialog: View {
    @Binding var isPresented: Bool
    @State private var vaccine: String = ""
    @State private var date: Date = Date()

    var addVaccine: (_ vaccine: String, _ date: String) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                VStack (spacing: 20){
                    Text("Upcoming Vaccine")
                        .font(.headline)
                        .padding()

                    TextField("Enter vaccine's name", text: $vaccine)
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
                            addVaccine(vaccine,dateString)
                            isPresented = false
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

