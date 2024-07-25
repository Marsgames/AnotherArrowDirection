//
//  GameView.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct GameView: View
{
    // Scoring
    private var initialLives = 3
    @State private var lives = 3
    @State private var score = 0

    // Animations
    @State private var xRotation = -5.5
    @State private var upscale = false

    // Difficulty / game loop
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State private var elapsedTime = 0.0
    @State private var speed = 50.0
    @State private var lastArrowGenerationTime = 0.0
    @State private var arrowGenerationInterval = 3.0
    
    @State private var arrows: [ArrowModel] = []
    
    var body: some View
    {
        ZStack
        {
            Background()
                .onAppear(perform: animateBubble)
                .onReceive(timer)
                { _ in
                    elapsedTime += 0.01

                    // Increase speed over time
                    speed += 0.01
                                    
                    // Adjust the interval based on the speed
                    arrowGenerationInterval = max(0.5, 3.0 - (speed / 100.0))
                                    
                    // Check if it's time to generate a new arrow
                    if elapsedTime - lastArrowGenerationTime >= arrowGenerationInterval
                    {
                        generateRandomArrow()
                        lastArrowGenerationTime = elapsedTime
                    }
                }
            
            VStack
            {
                HStack
                {
                    // TODO: Redo with a Bool array
                    Group
                    {
                        ForEach(0..<lives, id: \.self)
                        { _ in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .shadow(color: .red, radius: 2)
                        }
                        
                        if lives <= initialLives
                        {
                            ForEach(0..<initialLives - lives, id: \.self)
                            { _ in
                                Image(systemName: "heart")
                                    .foregroundColor(.gray)
                                    .shadow(color: .gray, radius: 2)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("Score: \(score)")
                }
                .padding()
                
                Spacer(minLength: 0)
                
                // TODO: Add "Good", "Perfect"... + animation depending on score added
                
                Spacer(minLength: 0)
                
                // Hide help over 3k score
                if let arrow = arrows.first,
                   score < 3000
                {
                    Text(arrow.swipeDirection.text)
                        .font(.caption)
                        .textCase(.uppercase)
                        .bold()
                        .foregroundColor(arrow.swipeDirection.color)
                }
            }
            
            // Image from Casala: https://cassala.itch.io/bubble-sprites
            if let arrow = arrows.first
            {
                Image("Bubble")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128)
                    .rotationEffect(.degrees(xRotation))
                    .rotation3DEffect(.degrees(xRotation), axis: (x: 1, y: 1, z: 0))
                    .opacity(xRotation > 0 ? 1 : 0.7)
                    .foregroundColor(arrow.swipeDirection.color)
                    .scaleEffect(upscale ? 1.5 : 1)
            }
            
            ForEach($arrows)
            { arrow in
                ArrowFigure(model: arrow, speed: $speed, loseLifeAction: loseOneLife, addScoreAction: {
                    increaseScore(amount: 100)
                    arrows.remove(at: 0)
                })
            }
        }
        .gesture(DragGesture()
            .onEnded
            { value in
                // If there is no arrows (between spawn)
                guard let arrow = arrows.first
                else
                {
                    loseOneLife()
                    return
                }
            
                // If user swipe before an arrow reach the bubble
                guard abs(arrow.currentOffset) <= 90
                else
                {
                    loseOneLife(removeArrow: false)
                    return
                }
            
                // If user swipe when direction is .None
                guard arrow.swipeDirection != .None
                else
                {
                    loseOneLife()
                    return
                }
            
                let dragDirection = dragDirection(gestureValue: value)
                switch arrow.swipeDirection
                {
                    case .Same:
                        if dragDirection == arrow.direction
                        {
                            increaseScore(amount: clamp(100 - abs(Int(arrow.currentOffset)), 0, 100))
                            arrows.remove(at: 0)
                        }
                        else
                        {
                            loseOneLife()
                        }

                    case .None:
                        // Already handled before
                        break
                    
                    case .Opposite:
                        if dragDirection == arrow.direction.opposite
                        {
                            increaseScore(amount: clamp(100 - abs(Int(arrow.currentOffset)), 0, 100))
                            arrows.remove(at: 0)
                        }
                        else
                        {
                            loseOneLife()
                        }
                
                    case .Another:
                        if arrow.direction.another.contains(dragDirection)
                        {
                            increaseScore(amount: clamp(100 - abs(Int(arrow.currentOffset)), 0, 100))
                            arrows.remove(at: 0)
                        }
                        else
                        {
                            loseOneLife()
                        }
                }
            }
        )
    }
    
    private func animateBubble()
    {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: true))
        {
            xRotation = 5.5
        }
        
        generateRandomArrow()
    }
    
    // Remark: Decided to do 1/4 instead of initial choice, because it's the changing of direction that is confusing, not a particular one
    private func generateRandomArrow()
    {
        let randomNumber = Int.random(in: 0 ... 100)
        switch score
        {
            // from 0 to 500, 100% chance to have .Same
            case 0..<500:
                arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Same))
            // from 500 to 1000, 50% chance to have .Same, 50% chance to have .Opposite
            case 500..<1000:
                if randomNumber < 50
                {
                    arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Same))
                }
                else
                {
                    arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Opposite))
                }
            // from 1000 to 2000, 20% chance to have .Same, 40% chance to have .Opposite, 40% chance to have .Another:
            case 1000..<2000:
                switch randomNumber
                {
                    case 0..<33:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Same))
                    case 33..<66:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Opposite))
                    default:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Another))
                }
            // over 1500, 5% chance to have .Same, 30% chance to have .Opposite, 60% chance to have .Another, 5% chance to have .None
            default:
                switch randomNumber
                {
                    case 0..<25:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Same))
                    case 25..<50:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Opposite))
                    case 50..<75:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .Another))
                    default:
                        arrows.append(ArrowModel(direction: EDirection.random, swipeDirection: .None))
                }
        }
    }
    
    private func loseOneLife(removeArrow: Bool = true)
    {
        lives -= 1
        if arrows.count > 0 && removeArrow
        {
            arrows.remove(at: 0)
        }
        if lives == 0
        {
            withAnimation
            {
                AppManager.shared.currentScreen = .EndGame(score: score)
            }
        }
    }
    
    private func increaseScore(amount: Int)
    {
        score += amount

        withAnimation(.spring(duration: 0.15))
        {
            upscale = true
        } completion: {
            withAnimation(.spring(duration: 0.15))
            {
                upscale = false
            }
        }
    }
}

#Preview
{
    GameView()
        .preferredColorScheme(.dark)
}
