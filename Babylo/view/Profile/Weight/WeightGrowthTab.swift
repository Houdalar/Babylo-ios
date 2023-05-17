//
//  WeightGrowthTab.swift
//  Babylo
//
//  Created by Babylo  on 17/5/2023.
//

import SwiftUI

struct WeightGrowth: View {
    @ObservedObject var babyViewModel: BabyViewModel
    @State private var selectedColumn: Int? = nil
    private let chartHeight: CGFloat = 350
    private let chartWidth: CGFloat = 350

    var body: some View {
        VStack {
            if babyViewModel.weights.count >= 1 {
    
                GeometryReader { geometry in
                    
                    WeightColumnChartView(weights: monthlyWeights, chartWidth: chartWidth, chartHeight: chartHeight, minY: minYValue, maxY: maxYValue,firstMonthIndex: firstMonthIndex)
                 
                        .frame(width: chartWidth, height: chartHeight)
                        .position(x: geometry.size.width / 2, y: chartHeight / 2)
                        .background(
                            weightChartAreaPath(chartHeight, chartWidth, weights, minY, yRange, pointSpacing)
                        )
                    
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.yellow, AppColors.lightYellow]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: chartWidth, height: chartHeight)
                        .position(x: geometry.size.width / 2, y: chartHeight / 2)
                    
                    axesPath(geometry, chartWidth, chartHeight)
                        .stroke(Color.black, lineWidth: 1)
                        
                       
                    
                    MonthLabelsView(geometry: geometry, chartWidth: chartWidth, chartHeight: chartHeight, pointSpacing: pointSpacing)
                    
                    WeightLabelsView(geometry: geometry, chartWidth: chartWidth, chartHeight: chartHeight)
                }
                .frame(height: 250)
                .padding(.bottom)
                .padding(.top,100)
                
                if let selected = selectedColumn {
                    Text("Height: \(babyViewModel.heights[selected].height)")
                        .padding(.top)
                }
            } else {
                Text("Not enough data to display the chart.")
            }
        }
    }
    
    var weights: [Weight] {
        babyViewModel.monthlyAverageWeights()
    }
    
    var minY: String {
        weights.min { Double($0.weight) ?? 0 < Double($1.weight) ?? 0 }?.weight ?? "0"
    }
    
    var maxY: String {
        weights.max { Double($0.weight) ?? 0 < Double($1.weight) ?? 0 }?.weight ?? "0"
    }
    
    var minYValue: Double {
        Double(minY) ?? 0
    }
    
    var maxYValue: Double {
        Double(maxY) ?? 0
    }
    
    var yRange: CGFloat {
        CGFloat(maxYValue - minYValue)
    }
    
    var pointSpacing: CGFloat {
        chartWidth / CGFloat(weights.count - 1)
    }
    
    var monthlyWeights: [Weight?] {
        prepareData(weights).weights
    }
    

    var firstMonthIndex: Int {
        prepareData(weights).firstMonthIndex
    }
    
    func prepareData(_ weights: [Weight]) -> (weights: [Weight?], firstMonthIndex: Int) {
        var weightsDict: [Int: Weight] = [:]
        var firstMonthIndex: Int?
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        for weight in weights {
            if let date = formatter.date(from: weight.date) {
                let month = Calendar.current.component(.month, from: date) - 1
                if firstMonthIndex == nil || month < firstMonthIndex! {
                    firstMonthIndex = month
                }
                if let existingWeight = weightsDict[month] {
                  
                    if let existingDate = formatter.date(from: existingWeight.date),
                       date > existingDate {
                        weightsDict[month] = weight
                    }
                } else {
                    // If no height exists for this month yet, store this one.
                    weightsDict[month] = weight
                }
            }
        }
        let sortedWeights = Array((0...11).map { weightsDict[$0] })  // Create a sorted array from the dictionary
        print("Prepared data: \(sortedWeights)")
        return (sortedWeights, firstMonthIndex ?? 0)
    }
}

struct WeightColumnChartView: View {
    @State private var selectedColumn: Int? = nil
    let weights: [Weight?]
    let chartWidth: CGFloat
    let chartHeight: CGFloat
    let minY: Double
    let maxY: Double
    let firstMonthIndex : Int

    // The y-axis range of your chart
       let chartMinY: Double = 2
       let chartMaxY: Double = 20

       // calculate the scale factor
       var scaleFactor: CGFloat {
           chartHeight / CGFloat(chartMaxY - chartMinY)
       }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: chartWidth / 24) {
            ForEach(firstMonthIndex..<weights.count, id: \.self) { index in
                VStack {
                    Spacer()
                    Group {
                        if let weight = weights[index] {
                            let weightValue = Double(weight.weight) ?? 0
                            let scaledWeight = CGFloat(weightValue - chartMinY) * scaleFactor  // Scale the height to fit the chart
                            
                            // Add a label on top of the column
                            if selectedColumn == index {
                                                       Text(weight.weight)
                                                            .font(.caption)
                                                           .padding(.bottom, 5)
                                                           .bold()
                                                           .foregroundColor(.black)
                                                   }
                            
                            Rectangle()
                                .fill(selectedColumn == index ? AppColors.lightOrange : Color.orange)
                                .frame(width: chartWidth / 24, height: scaledWeight)  // Use the scaled height
                                .onTapGesture {
                                    selectedColumn = index
                                }
                        } else {
                            // Add an empty Rectangle (invisible but takes up space) for months without height data
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: chartWidth / 24, height: 0)
                        }
                    }
                }
            }
        }
    }
}

struct WeightLabelsView: View {
    let geometry: GeometryProxy
    let chartWidth: CGFloat
    let chartHeight: CGFloat
    let labelFontSize: CGFloat = 12.0  // Adjust as needed
    let labelSpacing: CGFloat = 2.0    // Adjust this value to change the spacing between labels

    var body: some View {
        let heightMarks = stride(from: 2, through: 20, by: 2).map { String($0) }
        let yRange = 20 - 2
        let yStep = (chartHeight - labelFontSize - labelSpacing * 2) / CGFloat(yRange)

        ForEach(heightMarks, id: \.self) { mark in
            let yMarkValue = Double(mark) ?? 0
            let yPos = chartHeight - (CGFloat(yMarkValue - 2) / CGFloat(yRange)) * (chartHeight - labelFontSize - labelSpacing * 2) - labelSpacing
            Text(mark)
                .font(.system(size: labelFontSize))
                .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: yPos)
        }
}}

struct WeightMonthLabelsView: View {
    let geometry: GeometryProxy
    let chartWidth: CGFloat
    let chartHeight: CGFloat
    let pointSpacing: CGFloat
    let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul","Aug","Sept","Nov","Dec"]

    var body: some View {
        ForEach(0..<monthNames.count, id: \.self) { index in
                   let x = (geometry.size.width - chartWidth) / 2 + CGFloat(index) * (chartWidth / 11)
                   Text(monthNames[index])
                       .font(.footnote)
                       .position(x: x, y: chartHeight + 20)
               }
    }
}


