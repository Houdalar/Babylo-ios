//
//  AppointmentsView.swift
//  Babylo
//
//  Created by Babylo  on 4/5/2023.
//

import SwiftUI

struct AppointmentsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var babyViewModel: BabyViewModel
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var showAddAppointmentModel = false
    @State private var AppointIndexToDelete: Int?
    let babyName: String

    private var addButton: some View {
        Button(action: {
            showAddAppointmentModel = true
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
            let appointToDelete = babyViewModel.appointments[index]
            showAlert = true
            AppointIndexToDelete = index
        }
    }

    

       private func confirmDelete() {
           guard let index = AppointIndexToDelete else { return }
           let appointToDelete = babyViewModel.appointments[index]
           babyViewModel.deleteAppointment(token: UserDefaults.standard.string(forKey: "token") ?? "", date: appointToDelete.date, babyName: babyName, time: appointToDelete.time) { result in
               switch result {
               case .success(_):
                   DispatchQueue.main.async {
                       babyViewModel.appointments.removeAll { appoint in
                           appoint.id == appointToDelete.id
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
                        ForEach(babyViewModel.appointments) { appointment in
                            DoctorCard(doctor: appointment)
                        }
                        .onDelete(perform: delete)
                    }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Appointment"), message: Text("Are you sure you want to remove this doctor appointement ?"), primaryButton: .destructive(Text("Delete")) {
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
            babyViewModel.getAppointments(token: UserDefaults.standard.string(forKey: "token") ?? "", babyName: babyName) { result in
                switch result {
                case .success(_):
                    print("Appointments loaded successfully.")
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .overlay(showAddAppointmentModel ? CustomDoctorDialog(isPresented: $showAddAppointmentModel, addDoctor: { doctor,date, time in
            babyViewModel.addAppointment(token: UserDefaults.standard.string(forKey: "token") ?? "", doctor: doctor, date: date, babyName: babyName, time: time ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let doctor):
                        if !babyViewModel.appointments.contains(where: { $0.id == doctor.id }) {
                                            babyViewModel.appointments.append(doctor)
                                        }
                                        showAddAppointmentModel = false
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }) : nil)
    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        let babyViewModel = BabyViewModel()
        babyViewModel.appointments = [
            Doctor( doctor: "Dr. Doctor Name", babyId: "1", date: "04/05/2023", time: "15:00"),
            Doctor(doctor: "Dr. Doctor Name", babyId: "1", date: "04/05/2023", time: "15:00")
        ]
       return AppointmentsView(babyViewModel: babyViewModel, babyName: "Sample baby")
    }
}

struct DoctorCard: View {
    let doctor: Doctor
    @State private var offset: CGFloat = 0
   
    var body: some View {
        HStack {
            Text(doctor.doctor)
                .font(.system(size: 18))
                                .foregroundColor(.black)
                .padding(.leading)
            
           
            Spacer()
           
            VStack {
                Text(doctor.date)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                .padding(.trailing)
                .fontWeight(.bold)

                .padding(.bottom,5)
                
                Text(doctor.time)
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
                .padding(.trailing)
                .fontWeight(.bold)
            }
            
        }
        .padding()
        .background(AppColors.moreLighter)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
        
    }
}

struct CustomDoctorDialog: View {
    @Binding var isPresented: Bool
    @State private var doctor: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()

    

    var addDoctor: (_ doctor: String, _ date: String, _ time: String) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                VStack (spacing: 20){
                    Text("Upcoming Doctor Appointment")
                        .font(.headline)
                        .padding()

                    TextField("Enter doctor's name", text: $doctor)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)

                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                                     .padding()
                    
                    // Time Picker
                                       DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
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
                            
                            dateFormatter.dateFormat = "HH:mm"
                            let timeString = dateFormatter.string(from: time)
                                                        
                            
                            addDoctor(doctor,dateString,timeString)
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


