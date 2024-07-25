//
//  Enum.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

enum ESwipeDirection
{
    case Same
    case Opposite
    case Another
    case None

    var color: Color
    {
        switch self
        {
        case .Same:
            return .green
        case .Opposite:
            return .yellow
        case .Another:
            return .red
        case .None:
            return .gray
        }
    }

    var text: String
    {
        switch self
        {
        case .Same:
            return String(localized: "Same")
        case .Opposite:
            return String(localized: "Opposite")
        case .Another:
            return String(localized: "Another")
        case .None:
            return String(localized: "Do nothing")
        }
    }
}

enum EScreen
{
    case SplashScreen
    case Home
    case Tutorial
    case Game
    case EndGame(score: Int)
}

enum EDirection: String
{
    static var random: EDirection
    {
        return [EDirection.Up, .Right, .Down, .Left].randomElement()!
    }

    case Up
    case Right
    case Down
    case Left

    var arrowName: String
    {
        switch self
        {
        case .Up:
            return "arrow.up"
        case .Right:
            return "arrow.right"
        case .Down:
            return "arrow.down"
        case .Left:
            return "arrow.left"
        }
    }

    var opposite: EDirection
    {
        switch self
        {
        case .Up:
            return .Down
        case .Right:
            return .Left
        case .Down:
            return .Up
        case .Left:
            return .Right
        }
    }

    var another: [EDirection]
    {
        switch self
        {
        case .Up, .Down:
            return [.Right, .Left]
        case .Right, .Left:
            return [.Up, .Down]
        }
    }
}
