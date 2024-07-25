//
//  AnotherArrowDirectionApp.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

@main
struct AnotherArrowDirectionApp: App {
    var body: some Scene {
        WindowGroup {
            switch AppManager.shared.currentScreen
            {
            case .Home:
                Home()
                
            case .Tutorial:
                Tutorial()
                
            default:
                ContentView()
            
            }
        }
    }
}
