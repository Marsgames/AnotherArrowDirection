//
//  Home.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            Background()

            Button {
                AppManager.shared.currentScreen = .Tutorial
            } label: {
                Text("Play")
            }
        }
    }
}

#Preview {
    Home()
}
