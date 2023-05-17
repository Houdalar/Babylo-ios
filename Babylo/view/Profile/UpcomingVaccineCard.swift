//
//  UpcomingVaccineCard.swift
//  Babylo
//
//  Created by Babylo  on 5/5/2023.
//

import SwiftUI

struct UpcomingVaccineCard: View {
    let upcomingVaccine: UpcomingVaccine
    

    var body: some View {
        VStack {
            HStack {
                Text(upcomingVaccine.babyName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                .padding(.bottom, 4)
                .padding(.leading)
                Spacer()
            }
            

            HStack {
                Text(upcomingVaccine.vaccine)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.darkGray)
                    .padding(.leading)

                Spacer()

                Text(upcomingVaccine.date)
                    .font(.system(size: 15))
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
        }
        .padding()
        .background(AppColors.moreLighter)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}


struct UpcomingVaccineCard_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingVaccineCard(upcomingVaccine: UpcomingVaccine(vaccine: "Vaccine name",  date: "20/05/2023", babyName: "Sample Name"))
    }
}
