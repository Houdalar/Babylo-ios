//
//  WeightGrowthTab.swift
//  Babylo
//
//  Created by Babylo  on 26/4/2023.
//

import SwiftUI

struct WeightChartView: View {
    //let weights: [Weight]
    @State private var animationProgress: CGFloat = 0.0
    @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        GeometryReader { geometry in
            let chartHeight: CGFloat = 350
            let chartWidth: CGFloat = 350
            
            //let weights = self.weights.sorted { $0.date < $1.date }
            let weights = babyViewModel.monthlyAverageWeights()
            let minY = weights.min { Double($0.weight) ?? 0 < Double($1.weight) ?? 0 }?.weight ?? "0"
            let maxY = weights.max { Double($0.weight) ?? 0 < Double($1.weight) ?? 0 }?.weight ?? "0"
            let yRange = CGFloat((Double(maxY) ?? 0) - (Double(minY) ?? 0))
            
            let pointSpacing = chartWidth / CGFloat(weights.count - 1)

            // Draw the chart
//            weightChartPath(chartHeight, chartWidth, weights, minY, maxY, yRange, pointSpacing)
            AnimatedWeightChartPath(chartHeight: chartHeight, chartWidth: chartWidth, weights: weights, minY: minY, maxY: maxY, yRange: yRange, pointSpacing: pointSpacing, animationProgress: animationProgress)
            .stroke(Color.orange, lineWidth: 2)
            .background(
        weightChartAreaPath(chartHeight, chartWidth, weights, minY, yRange, pointSpacing)
           )
           .foregroundColor(.clear) // Make the chart path transparent
           .background(
               // Add the gradient color to the area beneath the chart line
               LinearGradient(
                   gradient: Gradient(colors: [AppColors.yellow, AppColors.lightYellow]),
                   startPoint: .top,
                   endPoint: .bottom
               )
           )
            .frame(width: chartWidth, height: chartHeight)
            .position(x: geometry.size.width / 2, y: chartHeight / 2)
            
            // Draw the axes
            axesPath(geometry, chartWidth, chartHeight)
            .stroke(Color.black, lineWidth: 1)
            
            
            // Draw weight values along the vertical axis
            /*ForEach(weights, id: \.id) { weight in
                let y = chartHeight - (CGFloat(Double(weight.weight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
                Text(weight.weight)
                    .font(.footnote)
                    .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: y)
            }*/
        }
        .frame(height: 250)
        .padding(.bottom)
        .padding(.top,100)
        .onAppear {
            withAnimation(.linear(duration: 1.2)) {
                animationProgress = 1.0
            }
        }
    }
}

struct WeightGrowthTab: View {
    @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        VStack {
            if babyViewModel.weights.count >= 1 {
                WeightChartView(babyViewModel: babyViewModel)
            } else {
                Text("Not enough data to display the chart.")
            }

        }

    }
}

// Define the sub-expressions for the chart path
func weightChartPath(_ chartHeight: CGFloat, _ chartWidth: CGFloat, _ weights: [Weight], _ minY: String, _ maxY: String, _ yRange: CGFloat, _ pointSpacing: CGFloat) -> Path {
    Path { path in
        for (index, weight) in weights.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let y = chartHeight - (CGFloat(Double(weight.weight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight

            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
}

func weightChartAreaPath(_ chartHeight: CGFloat, _ chartWidth: CGFloat, _ weights: [Weight], _ minY: String, _ yRange: CGFloat, _ pointSpacing: CGFloat) -> Path {
    Path { path in
        let firstWeight = weights.first?.weight ?? "0"
        let lastWeight = weights.last?.weight ?? "0"
        let firstY = chartHeight - (CGFloat(Double(firstWeight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
        path.move(to: CGPoint(x: 0, y: chartHeight))
        path.addLine(to: CGPoint(x: 0, y: firstY))
        path.addLine(to: CGPoint(x: CGFloat(weights.count - 1) * pointSpacing, y: chartHeight - (CGFloat(Double(lastWeight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight))
        path.addLine(to: CGPoint(x: 0, y: chartHeight))
        path.closeSubpath()
    }
}

struct AnimatedWeightChartPath: Shape {
    let chartHeight: CGFloat
    let chartWidth: CGFloat
    let weights: [Weight]
    let minY: String
    let maxY: String
    let yRange: CGFloat
    let pointSpacing: CGFloat
    var animationProgress: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for (index, weight) in weights.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let y = chartHeight - (CGFloat(Double(weight.weight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight

            if CGFloat(index) / CGFloat(weights.count) <= animationProgress {
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        return path
    }

    var animatableData: CGFloat {
        get { animationProgress }
        set { animationProgress = newValue }
    }
}



//struct WeightLabelsView: View {
//    let geometry: GeometryProxy
//    let chartWidth: CGFloat
//    let chartHeight: CGFloat
//    let labelFontSize: CGFloat = 12.0  // Adjust as needed
//    let labelSpacing: CGFloat = 2.0    // Adjust this value to change the spacing between labels
//
//    var body: some View {
//        let heightMarks = stride(from: 2, through: 20, by: 10).map { String($0) }
//        let yRange = 20 - 2
//        let yStep = (chartHeight - labelFontSize - labelSpacing * 2) / CGFloat(yRange)
//
//        ForEach(heightMarks, id: \.self) { mark in
//            let yMarkValue = Double(mark) ?? 0
//            let yPos = chartHeight - (CGFloat(yMarkValue - 40) / CGFloat(yRange)) * (chartHeight - labelFontSize - labelSpacing * 2) - labelSpacing
//            Text(mark)
//                .font(.system(size: labelFontSize))
//                .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: yPos)
//        }
//}}