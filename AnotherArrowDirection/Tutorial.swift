//
//  Tutorial.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct Tutorial: View {
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                Spacer(minLength: 0)
                
                TutorialCard(color: .green, colorName: String(localized: "green"), message: String(localized: "swipe in the direction of the arrow"), swipeDirection: .Same)
                
                Spacer(minLength: 0)
                
                TutorialCard(color: .yellow, colorName: String(localized: "yellow"), message: String(localized: "swipe in the opposite direction"), swipeDirection: .Opposite)
                
                Spacer(minLength: 0)
                
                TutorialCard(color: .red, colorName: String(localized: "red"), message: String(localized: "swipe in a direction that is not the same or the opposite"), swipeDirection: .Another)
                
                Spacer(minLength: 0)
                
                TutorialCard(color: .gray, colorName: String(localized: "gray"), message: String(localized: "do nothing!"), swipeDirection: .None)
                
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview("Dark") {
    Tutorial()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    Tutorial()
}
