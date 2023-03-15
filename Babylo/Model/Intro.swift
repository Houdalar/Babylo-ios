//
//  Intro.swift
//  Babylo
//
//  Created by Mac2021 on 13/3/2023.
//

import SwiftUI

// MARK : Intro Model And Sample Intro's
struct Intro : Identifiable{
    var id : String = UUID().uuidString
    var imageName : String
    var title : String
}

var intros : [Intro] = [
    .init(imageName: "Doctor", title: "Doctor Appointments and Vaccines"),
    .init(imageName: "Growth", title: "Baby's Growth"),
    .init(imageName: "Music", title: "Music & Audiobooks")
]

//MARK : Dummy Text
let dummyText = "Lorem Ipsum is simply dymmy text of printing and typesetting industry. \nLorem Ipsum is dummy text."
