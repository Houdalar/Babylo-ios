//
//  RatingDialog.swift
//  Babylo
//
//  Created by Babylo  on 18/5/2023.
//

import SwiftUI

struct RatingDialogView: View {
    @Binding var isShowing: Bool
    @Binding var rating: Double
    let submitAction: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            if isShowing {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)

                    VStack(alignment: .center,spacing: 20) {
                        Text("Rate the book")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding()
                        HStack {
                            Spacer()
                        CosmosRatingView(rating: $rating)
                            .frame(height: 10)
                            .padding(.horizontal,30)
                            .padding(.bottom,10)
                           
                        }

                        Divider()
                            .padding(.bottom,2)

                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    isShowing = false
                                }
                            }) {
                                Text("Cancel")
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .foregroundColor(Color.blue)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    isShowing = false
                                    submitAction()
                                }
                            }) {
                                Text("Submit")
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .foregroundColor(Color.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(15)
                    .frame(width: 300, height: 100)
                    .shadow(radius: 10)
                }
            }
        }
    }
}



struct RatingDialogView_Previews: PreviewProvider {
    @State static var isShowing = true
    @State static var rating: Double = 4.0

    static var previews: some View {
        RatingDialogView(isShowing: $isShowing, rating: $rating, submitAction: {
            print("Submit action triggered with rating: \(rating)")
        })
    }
}
