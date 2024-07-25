//
//  ArrowModel.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUICore
import UIKit

struct ArrowModel: Identifiable {
    let id = UUID().uuidString
    let direction: EDirection
    let swipeDirection: ESwipeDirection
    let color: Color
    var originalOffset: CGFloat = -UIScreen.main.bounds.height / 2
    var currentOffset: CGFloat

    init(direction: EDirection, swipeDirection: ESwipeDirection) {
        self.direction = direction
        self.swipeDirection = swipeDirection
        color = swipeDirection.color
        currentOffset = originalOffset
    }
}
