//
//  CGPoint+Extension.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import Foundation

extension CGPoint
{
    static func - (left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}
