//
//  AudioBookHomePage.swift
//  Babylo
//
//  Created by houda lariani on 5/5/2023.
//

import SwiftUI

enum BookTab : CaseIterable {

    case overview, Bookshelf

}


struct AudioBookHomePage: View {
    @State private var selectedTab: BookTab = .overview

    var body: some View {
        VStack(alignment: .leading) {
            Text("Audio Books")
                .foregroundColor(Color.gray)
                .padding(.horizontal, 20)
                .font(Font.system(size: 25))
                .padding(.top, 20)

           

            HStack(alignment:.center,spacing: 10) {
                Spacer()
                ForEach(BookTab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Text(tab.title)
                            .font(.system(size: 14))
                            .fontWeight(selectedTab == tab ? .bold : .regular)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(selectedTab == tab ? Color.yellow : Color.white)
                            )
                            .foregroundColor(selectedTab == tab ? Color.white : Color.gray)
                    }
                }
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)

           
            switch selectedTab {
            case .overview:
                NavigationView {
                    AudioBookOverviewView()
                }
            case .Bookshelf:
                NavigationView {
                    BookShelf()
                }
            }
        }
    }
}

extension BookTab {

    var title: String {

        switch self {

        case .overview:

            return "Overview"

        case .Bookshelf:

            return "Bookshelf"

        

        }

    }

}


struct AudioBookHomePage_Previews: PreviewProvider {
    static var previews: some View {
        AudioBookHomePage()
    }
}
