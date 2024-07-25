//
//  Home.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import OSLog
import SwiftUI

struct Home: View {
    private let Log = Logger(subsystem: "AnotherArrowDirection", category: "Home")
    private let bestScore = UserDefaults.standard.integer(forKey: "bestScore")

    var body: some View {
        ZStack {
            Background()

            VStack {
#if targetEnvironment(simulator)
                // Xcode 16 beta is buggy with preview of images and colors, so I'm using this rectangle to simulate the image
                Rectangle()
                    .frame(width: 160, height: 160)
                    .padding(.top, 64)
                    .padding(.bottom)
#else
                // App Logo
                Image(.headcrabLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .padding(.top, 64)
                    .padding(.bottom)
#endif
                Text("Another Arrow Direction")
                    .font(.system(.title, design: .rounded))
                    .bold()

                Spacer(minLength: 0)
                
                if bestScore > 0 {
                    Text("Best score: \(bestScore)")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                }

                Spacer(minLength: 0)

                Button {
                    if UserDefaults.standard.bool(forKey: "completedTutorial") {
                        AppManager.shared.currentScreen = .Game
                        Log.info("Go to game screen")
                    }
                    else {
                        AppManager.shared.currentScreen = .Tutorial
                        Log.info("Go to tutorial screen")
                    }
                } label: {
                    HStack {
                        Spacer()

                        Text("Play")
                            .foregroundColor(.white)
                            .textCase(.uppercase)
                            .font(.title3)
                            .bold()
                            .padding(10)

                        Spacer()
                    }
                    .background {
                        Capsule()
                            .stroke(style: StrokeStyle(lineWidth: 2))
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
