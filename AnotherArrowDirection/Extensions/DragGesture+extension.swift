//
//  DragGesture+extension.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

//
func dragDirection(gestureValue: DragGesture.Value) -> EDirection {
    let translation = pointToSize(gestureValue.predictedEndLocation - gestureValue.location)
    let angle = atan2(translation.height, translation.width)
    let direction = angleToDirection(Double(angle))
    return direction
}

private func angleToDirection(_ angle: Double) -> EDirection {
    if angle < -2.35619449019234 || angle > 2.35619449019234 {
        return .Left
    } else if angle < -0.7853981633974483 && angle > -2.35619449019234 {
        return .Up
    } else if angle < 0.7853981633974483 && angle > -0.7853981633974483 {
        return .Right
    } else {
        return .Down
    }
}

private func pointToSize(_ point: CGPoint) -> CGSize {
    return CGSize(width: point.x, height: point.y)
}
