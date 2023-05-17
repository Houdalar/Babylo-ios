//
//  HeightChartView.swift
//  Babylo
//
//  Created by Babylo  on 16/5/2023.
//

import SwiftUI

struct HeightChartView: View {
    @ObservedObject var babyViewModel: BabyViewModel
    @State private var selectedColumn: Int? = nil
    private let chartHeight: CGFloat = 350
    private let chartWidth: CGFloat = 350

    var body: some View {
        VStack {
            if babyViewModel.heights.count >= 1 {
    
                GeometryReader { geometry in
                    
                    ColumnChartView(heights: monthlyHeights, chartWidth: chartWidth, chartHeight: chartHeight, minY: minYValue, maxY: maxYValue,firstMonthIndex: firstMonthIndex)
                 
                        .frame(width: chartWidth, height: chartHeight)
                        .position(x: geometry.size.width / 2, y: chartHeight / 2)
                        .background(
                            chartAreaPath(chartHeight, chartWidth, heights, minY, yRange, pointSpacing)
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
                    
                    HeightLabelsView(geometry: geometry, chartWidth: chartWidth, chartHeight: chartHeight)
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
    
    var heights: [Height] {
        babyViewModel.monthlyAverageHeights()
    }
    
    var minY: String {
        heights.min { Double($0.height) ?? 0 < Double($1.height) ?? 0 }?.height ?? "0"
    }
    
    var maxY: String {
        heights.max { Double($0.height) ?? 0 < Double($1.height) ?? 0 }?.height ?? "0"
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
        chartWidth / CGFloat(heights.count - 1)
    }
    
    var monthlyHeights: [Height?] {
        prepareData(heights).heights
    }
    

    var firstMonthIndex: Int {
        prepareData(heights).firstMonthIndex
    }
    
    func prepareData(_ heights: [Height]) -> (heights: [Height?], firstMonthIndex: Int) {
        var heightsDict: [Int: Height] = [:]
        var firstMonthIndex: Int?
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        for height in heights {
            if let date = formatter.date(from: height.date) {
                let month = Calendar.current.component(.month, from: date) - 1
                if firstMonthIndex == nil || month < firstMonthIndex! {
                    firstMonthIndex = month
                }
                if let existingHeight = heightsDict[month] {
                    // If a height already exists for this month, compare the dates and keep the latest one.
                    if let existingDate = formatter.date(from: existingHeight.date),
                       date > existingDate {
                        heightsDict[month] = height
                    }
                } else {
                    // If no height exists for this month yet, store this one.
                    heightsDict[month] = height
                }
            }
        }
        let sortedHeights = Array((0...11).map { heightsDict[$0] })  // Create a sorted array from the dictionary
        print("Prepared data: \(sortedHeights)")
        return (sortedHeights, firstMonthIndex ?? 0)
    }
}

struct ColumnChartView: View {
    @State private var selectedColumn: Int? = nil
    let heights: [Height?]
    let chartWidth: CGFloat
    let chartHeight: CGFloat
    let minY: Double
    let maxY: Double
    let firstMonthIndex : Int

    // The y-axis range of your chart
       let chartMinY: Double = 40
       let chartMaxY: Double = 120

       // calculate the scale factor
       var scaleFactor: CGFloat {
           chartHeight / CGFloat(chartMaxY - chartMinY)
       }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: chartWidth / 24) {
            ForEach(firstMonthIndex..<heights.count, id: \.self) { index in
                VStack {
                    Spacer()
                    Group {
                        if let height = heights[index] {
                            let heightValue = Double(height.height) ?? 0
                            let scaledHeight = CGFloat(heightValue - chartMinY) * scaleFactor  // Scale the height to fit the chart
                            
                            // Add a label on top of the column
                            if selectedColumn == index {
                                                       Text(height.height)
                                                            .font(.caption)
                                                           .padding(.bottom, 5)
                                                           .bold()
                                                           .foregroundColor(.black)
                                                   }
                            
                            Rectangle()
                                .fill(selectedColumn == index ? AppColors.lightOrange : Color.orange)
                                .frame(width: chartWidth / 24, height: scaledHeight)  // Use the scaled height
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


struct MonthLabelsView: View {
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

struct HeightLabelsView: View {
    let geometry: GeometryProxy
    let chartWidth: CGFloat
    let chartHeight: CGFloat
    let labelFontSize: CGFloat = 12.0  // Adjust as needed
    let labelSpacing: CGFloat = 2.0    // Adjust this value to change the spacing between labels

    var body: some View {
        let heightMarks = stride(from: 40, through: 120, by: 10).map { String($0) }
        let yRange = 120 - 40
        let yStep = (chartHeight - labelFontSize - labelSpacing * 2) / CGFloat(yRange)

        ForEach(heightMarks, id: \.self) { mark in
            let yMarkValue = Double(mark) ?? 0
            let yPos = chartHeight - (CGFloat(yMarkValue - 40) / CGFloat(yRange)) * (chartHeight - labelFontSize - labelSpacing * 2) - labelSpacing
            Text(mark)
                .font(.system(size: labelFontSize))
                .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: yPos)
        }
}}

