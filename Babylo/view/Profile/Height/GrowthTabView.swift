//  GrowthTabView.swift
//  Babylo
//
//  Created by Babylo  on 25/4/2023.
//

import SwiftUI

struct GrowthTabView: View {
   @ObservedObject var babyViewModel: BabyViewModel
   @State private var animationProgress: CGFloat = 0.0
    @State private var selectedColumn: Int? = nil


    var body: some View {
        
        VStack {
            if babyViewModel.heights.count >= 1 {
                GeometryReader { geometry in
                    let chartHeight: CGFloat = 350
                    let chartWidth: CGFloat = 350
                    
                    //let heights = babyViewModel.heights.sorted { $0.date < $1.date }
                    let heights = babyViewModel.monthlyAverageHeights()

                    let minY = heights.min { Double($0.height) ?? 0 < Double($1.height) ?? 0 }?.height ?? "0"
                    let maxY = heights.max { Double($0.height) ?? 0 < Double($1.height) ?? 0 }?.height ?? "0"
                    let yRange = CGFloat((Double(maxY) ?? 0) - (Double(minY) ?? 0))
                    
                    let pointSpacing = chartWidth / CGFloat(heights.count - 1)


                    // Draw the chart
                    /*chartPath(chartHeight, chartWidth, heights, minY, maxY, yRange, pointSpacing)*/
                    
                    AnimatedChartPath(chartHeight: chartHeight, chartWidth: chartWidth, heights: heights, minY: minY, maxY: maxY, yRange: yRange, pointSpacing: pointSpacing, animationProgress: animationProgress)
                        


                    .stroke(Color.orange, lineWidth: 3)
                    .background(
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
                    axesPath(geometry, chartWidth, chartHeight)
                    .stroke(Color.black, lineWidth: 1)
                    
//                    MonthLabelsView(geometry: geometry, chartWidth: chartWidth, chartHeight: chartHeight, heights: heights, pointSpacing: pointSpacing)
                    
                    
                    HeightLabelsView(geometry: geometry, chartWidth: chartWidth, chartHeight: chartHeight)
                    
                    // Display height values
                  /*  ForEach(heights, id: \.id) { height in
                        let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight
                        Text(height.height)
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


            } else {
                Text("Not enough data to display the chart.")
            }
            HStack{
                Text("-")
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
                    
                Text(": Monthly height growth")
            }
            .padding(.top,120)
            .padding(.trailing,170)

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

/*func chartPath(_ chartHeight: CGFloat, _ chartWidth: CGFloat, _ heights: [Height], _ minY: String, _ maxY: String, _ yRange: CGFloat, _ pointSpacing: CGFloat, _ animationProgress: CGFloat) -> Path {
    Path { path in
        for (index, height) in heights.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight

            if CGFloat(index) / CGFloat(heights.count) <= animationProgress {
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
    }
}*/



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

struct AnimatedChartPath: Shape {
    let chartHeight: CGFloat
    let chartWidth: CGFloat
    let heights: [Height]
    let minY: String
    let maxY: String
    let yRange: CGFloat
    let pointSpacing: CGFloat
    var animationProgress: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for (index, height) in heights.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let y = chartHeight - (CGFloat(Double(height.height) ?? 0) - CGFloat(Double(minY) ?? 0)) / yRange * chartHeight

            if CGFloat(index) / CGFloat(heights.count) <= animationProgress {
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


