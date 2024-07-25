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
                
                TutorialCard(actionValidated: $completed[0], message: String(localized: "swipe in the direction of the arrow"), swipeDirection: .Same, colorName: String(localized: "green"))
                
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[1], message: String(localized: "swipe in the opposite direction"), swipeDirection: .Opposite, colorName: String(localized: "yellow"))
                
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[2], message: String(localized: "swipe in a direction that is not the same or the opposite"), swipeDirection: .Another, colorName: String(localized: "red"))
                
                Spacer(minLength: 0)
                
                TutorialCard(actionValidated: $completed[3], message: String(localized: "do nothing!"), swipeDirection: .None, colorName: String(localized: "gray"))
                
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
