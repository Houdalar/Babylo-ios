//
//  WeightGrowthTab.swift
//  Babylo
//
//  Created by Babylo  on 26/4/2023.
//

import SwiftUI

struct WeightChartView: View {
    let weights: [Weight]

    var body: some View {
        GeometryReader { geometry in
            let chartHeight: CGFloat = 350
            let chartWidth: CGFloat = 350
            
            let weights = self.weights.sorted { $0.date < $1.date }
            let minY = weights.min { Double($0.weight) ?? 0 < Double($1.weight) ?? 0 }?.weight ?? "0"
            let maxY = weights.max { Double($0.weight) ?? 0 < Double($1.weight) ?? 0 }?.weight ?? "0"
            let yRange = CGFloat((Double(maxY) ?? 0) - (Double(minY) ?? 0))
            
            let pointSpacing = chartWidth / CGFloat(weights.count - 1)

            // Draw the chart
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
            .stroke(Color.yellow, lineWidth: 2)
            .frame(width: chartWidth, height: chartHeight)
            .position(x: geometry.size.width / 2, y: chartHeight / 2)
            
            // Draw the axes
            Path { path in
                path.move(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: 0))
                path.addLine(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: chartHeight))
                path.move(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: chartHeight))
                path.addLine(to: CGPoint(x: (geometry.size.width + chartWidth) / 2, y: chartHeight))
            }
            .stroke(Color.black, lineWidth: 1)
            
            // Draw weight values along the vertical axis
            ForEach(weights, id: \.id) { weight in
                let y = chartHeight - (CGFloat(Double(weight.weight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
                Text(weight.weight)
                    .font(.footnote)
                    .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: y)
            }
        }
        .frame(height: 250)
        .padding(.bottom)
        .padding(.top,100)
    }
}

struct WeightGrowthTab: View {
    @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        VStack {
            if babyViewModel.weights.count >= 1 {
                WeightChartView(weights: babyViewModel.weights)
            } else {
                Text("Not enough data to display the chart.")
            }
        }

    }
}

