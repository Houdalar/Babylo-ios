//
//  GrowthTabView.swift
//  Babylo
//
//  Created by Babylo  on 25/4/2023.
//

/*import SwiftUI

struct GrowthTabView: View {
    @ObservedObject var babyViewModel : BabyViewModel
    
    
    var body: some View {
        VStack {
            if babyViewModel.heights.count > 1 {
                GeometryReader { geometry in
                    Chart(heights: babyViewModel.heights, chartWidth: 400, chartHeight: 400)
                        .frame(width: 350, height: 250)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            } else {
                Text("Not enough data for chart.")
            }
        }
    }
}

struct Chart: View {
    let heights: [Height]
    let chartWidth: CGFloat
    let chartHeight: CGFloat

    var body: some View {
        ZStack {
            ChartLines(heights: heights, chartWidth: chartWidth, chartHeight: chartHeight)
            ChartPoints(heights: heights, chartWidth: chartWidth, chartHeight: chartHeight)
            ChartAxes(chartWidth: chartWidth, chartHeight: chartHeight)
            HeightValues(heights: heights, chartWidth: chartWidth, chartHeight: chartHeight)
        }
    }
}

struct ChartLines: View {
    let heights: [Height]
    let chartWidth: CGFloat
    let chartHeight: CGFloat

    var body: some View {
        Path { path in
            let points = getNormalizedPoints(heights: heights, chartWidth: chartWidth, chartHeight: chartHeight)
            path.move(to: points.first ?? .zero)
            for point in points {
                path.addLine(to: point)
            }
        }
        .stroke(Color.yellow, lineWidth: 2)
    }
}

struct ChartPoints: View {
    let heights: [Height]
    let chartWidth: CGFloat
    let chartHeight: CGFloat

    var body: some View {
        ForEach(getNormalizedPoints(heights: heights, chartWidth: chartWidth, chartHeight: chartHeight), id: \.self) { point in
            Circle()
                .fill(Color.yellow)
                .frame(width: 6, height: 6)
                .position(point)
        }
    }
}

struct ChartAxes: View {
    let chartWidth: CGFloat
    let chartHeight: CGFloat

    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            Spacer()
        }
        .frame(width: chartWidth, height: chartHeight)
        .border(Color.gray, width: 1)
    }
}

struct HeightValues: View {
    let heights: [Height]
    let chartWidth: CGFloat
    let chartHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: chartHeight / CGFloat(heights.count) - 12) {
            ForEach(heights, id: \.id) { height in
                Text(height.height)
                    .font(.system(size: 12))
            }
        }
        .frame(height: chartHeight)
        .offset(x: -chartWidth / 2 + 16, y: 0)
    }
}

private func getNormalizedPoints(heights: [Height], chartWidth: CGFloat, chartHeight: CGFloat) -> [CGPoint] {
    let minY = heights.map { Int($0.height) ?? 0 }.min() ?? 0
    let maxY = heights.map { Int($0.height) ?? 0 }.max() ?? 0

    let yRange = CGFloat(maxY - minY)
    let yIncrement = yRange > 0 ? chartHeight / yRange : 0

    let xIncrement = chartWidth / CGFloat(heights.count - 1)

    return heights.enumerated().map { index, height in
        let y = chartHeight - (CGFloat(Int(height.height) ?? 0) - CGFloat(minY)) * yIncrement
        let x = CGFloat(index) * xIncrement
        return CGPoint(x: x, y: y)
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(x)-\(y)")
    }
}*/

import SwiftUI

struct GrowthTabView: View {
    @ObservedObject var babyViewModel: BabyViewModel

    var body: some View {
        VStack {
            if babyViewModel.heights.count >= 1 {
                GeometryReader { geometry in
                    let chartHeight: CGFloat = 350
                    let chartWidth: CGFloat = 350
                    
                    let heights = babyViewModel.heights.sorted { $0.date < $1.date }
                    let minY = heights.min { Double($0.height) ?? 0 < Double($1.height) ?? 0 }?.height ?? "0"
                    let maxY = heights.max { Double($0.height) ?? 0 < Double($1.height) ?? 0 }?.height ?? "0"
                    let yRange = CGFloat((Double(maxY) ?? 0) - (Double(minY) ?? 0))
                    
                    let pointSpacing = chartWidth / CGFloat(heights.count - 1)

                    // Draw the chart
//                    Path { path in
//                        for (index, height) in heights.enumerated() {
//                            let x = CGFloat(index) * pointSpacing
//                            let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
//
//                            if index == 0 {
//                                path.move(to: CGPoint(x: x, y: y))
//                            } else {
//                                path.addLine(to: CGPoint(x: x, y: y))
//                            }
//                        }
//                    }
                    // Draw the chart
                    chartPath(chartHeight, chartWidth, heights, minY, maxY, yRange, pointSpacing)
                    .stroke(Color.orange, lineWidth: 2)
                    .background(
                    // Create a new Path shape that fills the area beneath the chart line
//                       Path { path in
//                          let firstHeight = heights.first?.height ?? "0"
//                          let lastHeight = heights.last?.height ?? "0"
//                          let firstY = chartHeight - (CGFloat(Double(firstHeight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
//                           path.move(to: CGPoint(x: 0, y: chartHeight))
//                           path.addLine(to: CGPoint(x: 0, y: firstY))
//                           path.addLine(to: CGPoint(x: CGFloat(heights.count - 1) * pointSpacing, y: chartHeight))
//                           path.addLine(to: CGPoint(x: 0, y: chartHeight))
//                           path.closeSubpath()
//                       }
                chartAreaPath(chartHeight, chartWidth, heights, minY, yRange, pointSpacing)
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
//                    Path { path in
//                        path.move(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: 0))
//                        path.addLine(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: chartHeight))
//                        path.move(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: chartHeight))
//                        path.addLine(to: CGPoint(x: (geometry.size.width + chartWidth) / 2, y: chartHeight))
//                    }
                    axesPath(geometry, chartWidth, chartHeight)
                    .stroke(Color.black, lineWidth: 1)
                    
                    // Draw height values along the vertical axis
//                    ForEach(heights, id: \.id) { height in
//                        let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
//                        Text(height.height)
//                            .font(.footnote)
//                            .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: y)
//
//                    }
                    heightValues(chartHeight,chartWidth, minY, yRange, heights, pointSpacing, geometry)
                        .position(x: (geometry.size.width - chartWidth) / 2, y: chartHeight / 2)
                }
                .frame(height: 250)
                .padding(.bottom)
                .padding(.top,100)
            } else {
                Text("Not enough data to display the chart.")
            }
            HStack{
                Text("-")
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
                    
                Text(": Height growth")
            }
            .padding(.top,120)
            .padding(.trailing,200)

        }
    }
}

// Define the sub-expressions for the chart path
func chartPath(_ chartHeight: CGFloat, _ chartWidth: CGFloat, _ heights: [Height], _ minY: String, _ maxY: String, _ yRange: CGFloat, _ pointSpacing: CGFloat) -> Path {
    Path { path in
        for (index, height) in heights.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight

            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
}

// Define the sub-expression for the height values
func heightValues(_ chartHeight: CGFloat,_ chartWidth: CGFloat, _ minY: String, _ yRange: CGFloat, _ heights: [Height], _ pointSpacing: CGFloat, _ geometry: GeometryProxy) -> some View {
    VStack {
        ForEach(heights, id: \.id) { height in
            let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
            Text(height.height)
                .font(.footnote)
                .position(x: (geometry.size.width - chartWidth) / 2 - 20, y: y)
        }
    }
}

// Define the sub-expression for the axes path
func axesPath(_ geometry: GeometryProxy, _ chartWidth: CGFloat, _ chartHeight: CGFloat) -> Path {
    Path { path in
        path.move(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: 0))
        path.addLine(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: chartHeight))
        path.move(to: CGPoint(x: (geometry.size.width - chartWidth) / 2, y: chartHeight))
        path.addLine(to: CGPoint(x: (geometry.size.width + chartWidth) / 2, y: chartHeight))
    }
}

func chartAreaPath(_ chartHeight: CGFloat, _ chartWidth: CGFloat, _ heights: [Height], _ minY: String, _ yRange: CGFloat, _ pointSpacing: CGFloat) -> Path {
    Path { path in
        let firstHeight = heights.first?.height ?? "0"
        let lastHeight = heights.last?.height ?? "0"
        let firstY = chartHeight - (CGFloat(Double(firstHeight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
        path.move(to: CGPoint(x: 0, y: chartHeight))
        path.addLine(to: CGPoint(x: 0, y: firstY))
        path.addLine(to: CGPoint(x: CGFloat(heights.count - 1) * pointSpacing, y: chartHeight - (CGFloat(Double(lastHeight) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight))
        path.addLine(to: CGPoint(x: 0, y: chartHeight))
        path.closeSubpath()
    }
}



