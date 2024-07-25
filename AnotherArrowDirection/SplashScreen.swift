//
//  SplashScreen.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import OSLog
import SwiftData
import SwiftUI

struct SplashScreen: View
{
    private let Log = Logger(subsystem: "Coming Soon", category: "SplashScreen")

    @State private var opacity = 0.0

    var body: some View
    {
        ZStack
        {
            Background()
                .onAppear
                {
                    withAnimation(.easeInOut(duration: 1))
                    {
                        opacity = 1
                    } completion:
                    {
                        withAnimation(Animation.easeInOut(duration: 2))
                        {
                            opacity = 0
                        } completion: {
                            AppManager.shared.currentScreen = .Home
                        }
                    }
                }

            // Splash screen Headcrab
            Image(.headcrabLogo)
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .opacity(opacity)
        }
    }
}

#Preview("Dark")
{
    SplashScreen().preferredColorScheme(.dark)
}

#Preview("Light")
{
    SplashScreen()
}
