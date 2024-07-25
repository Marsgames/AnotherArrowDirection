//
//  Tutorial.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import OSLog
import SwiftUI

struct Tutorial: View {
    private let Log = Logger(subsystem: "AnotherArrowDirection", category: "Tutorial")
    @State private var completed: [Bool] = [false, false, false, false]
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[0], color: .green, colorName: String(localized: "green"), message: String(localized: "swipe in the direction of the arrow"), swipeDirection: .Same)
                
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[1], color: .yellow, colorName: String(localized: "yellow"), message: String(localized: "swipe in the opposite direction"), swipeDirection: .Opposite)
                
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[2], color: .red, colorName: String(localized: "red"), message: String(localized: "swipe in a direction that is not the same or the opposite"), swipeDirection: .Another)
                
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[3], color: .gray, colorName: String(localized: "gray"), message: String(localized: "do nothing!"), swipeDirection: .None)
                
                Spacer(minLength: 0)
            }
            .onChange(of: completed) { _, _ in
                if completed.allSatisfy({ $0 }) {
                    Log.info("Tutorial completed. Go to game")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        AppManager.shared.currentScreen = .Game
                        UserDefaults.standard.setValue(true, forKey: "completedTutorial")
                    }
                }
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
