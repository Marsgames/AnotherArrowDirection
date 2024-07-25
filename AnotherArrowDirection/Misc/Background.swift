//
//  Background.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct Background: View {
    var body: some View {
        LinearGradient(colors: [.topGradient, .bottomGradient], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

#Preview("Dark") {
    Background()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
