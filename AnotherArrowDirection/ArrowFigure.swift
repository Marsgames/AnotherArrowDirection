//
//  ArrowFigure.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct ArrowFigure: View {
    @Binding var model: ArrowModel
    @Binding var speed: Double
    var loseLifeAction: (Bool) -> Void
    var addScoreAction: () -> Void

    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State private var elapsedTime = 0.0

    var body: some View {
        Image(systemName: model.direction.arrowName)
            .resizable()
            .scaledToFit()
            .frame(width: 64)
            .shadow(color: .white, radius: 2)
            .bold()
            .offset(y: model.currentOffset)
            .onReceive(timer) { _ in
                elapsedTime += 0.01
                model.currentOffset = model.originalOffset + elapsedTime * speed
                if abs(model.currentOffset) < 10 && model.swipeDirection == .None {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001)
                    {
                        addScoreAction()
                    }
                }

                if model.currentOffset > 90 {
                    loseLifeAction(true)
                }
            }
    }
}

#Preview {
    ArrowFigure(model: .constant(ArrowModel(direction: .Right, swipeDirection: .Same)), speed: .constant(50), loseLifeAction: { _ in print("end of the game") }, addScoreAction: {})
}
