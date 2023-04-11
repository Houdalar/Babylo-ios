//
//  AppColors.swift
//  Babylo
//
//  Created by houda lariani on 14/3/2023.
//

import SwiftUI


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct AppColors{
    static let primary = Color.yellow
    static let primarydark = Color(red:166/255 , green:109/255 , blue:9/255)
    static let lightColor = Color(red:253/255 , green: 248/255 , blue: 229/255)
    
}
