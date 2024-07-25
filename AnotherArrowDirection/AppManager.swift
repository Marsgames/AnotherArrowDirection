//
//  AppManager.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import Foundation

@Observable
final class AppManager {
    static var shared = AppManager()

    var currentScreen = EScreen.SplashScreen
}
