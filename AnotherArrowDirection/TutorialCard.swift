//
//  TutorialCard.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct TutorialCard: View
{
    @Binding var actionValidated: Bool

    var color: Color
    var colorName: String

    var message: String
    var swipeDirection: ESwipeDirection

    @State private var valueTranslation: CGSize = .zero
    @State private var isDragging = false

    @State private var wiggle = false

    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .frame(height: 150)
                .padding(.horizontal)

            if actionValidated
            {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .fill(color)
                    .blur(radius: 3)
                    .frame(height: 150)
                    .padding(.horizontal)
            }

            HStack
            {
                ZStack
                {
                    Circle()
                        .fill(.thickMaterial)
                        .frame(height: 64)
                        .shadow(radius: 4, x: 2, y: 2)

                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .fill(.background)
                        .frame(height: 64)

                    switch swipeDirection
                    {
                    case .Same:
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .shadow(color: .white, radius: 2)
                            .bold()
                    case .Opposite:
                        Image(systemName: "arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .shadow(color: .white, radius: 2)
                            .bold()
                    case .Another:
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .shadow(color: .white, radius: 2)
                            .bold()
                    case .None:
                        Image(systemName: "arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .shadow(color: .white, radius: 2)
                            .bold()
                    }
                }

                VStack(alignment: .leading)
                {
                    if actionValidated
                    {
                        Text("If the bubble is \(colorName)")
                    }

                    Text(message)
                }

                Spacer(minLength: 0)

                if swipeDirection == .None
                {
                    Image(systemName: "hand.tap")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .shadow(color: .white, radius: 2)
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 25)
            .padding(.trailing)
        }
        .sensoryFeedback(.increase, trigger: actionValidated)
        .rotationEffect(.degrees(wiggle ? 2.5 : 0))
        .gesture(DragGesture()
            .onEnded
            { value in
                guard !actionValidated else { return }

                let direction = dragDirection(gestureValue: value)

                switch (swipeDirection, direction)
                {
                case (.Same, .Right), (.Opposite, .Up), (.Another, .Up), (.Another, .Down):
                    withAnimation
                    {
                        actionValidated = true
                    }

                    doWiggle()

                default:
                    break
                }
            }
        )
        .onTapGesture
        {
            guard swipeDirection == .None, !actionValidated else { return }

            withAnimation
            {
                actionValidated = true
            }

            doWiggle()
        }
    }

    private func doWiggle()
    {
        withAnimation(.easeIn(duration: 0.15).repeatCount(2, autoreverses: true))
        {
            wiggle = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)
        {
            withAnimation
            {
                wiggle = false
            }
        }
    }
}

#Preview("Dark")
{
    @Previewable @State var completed = false
    ZStack
    {
        Background()

        TutorialCard(actionValidated: $completed, color: .green, colorName: "green", message: "swipe in the direction of the arrow", swipeDirection: .Same)
            .preferredColorScheme(.dark)
    }
}

#Preview("Light")
{
    @Previewable @State var completed = false

    ZStack
    {
        Background()

        TutorialCard(actionValidated: $completed, color: .green, colorName: "green", message: "swipe in the direction of the arrow", swipeDirection: .Same)
    }
}
