//
//  ShakeEffect.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUICore

struct ShakeEffect: GeometryEffect
{
    var amount: CGFloat = 10
    var shakesPerUnit: Int = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(rotationAngle: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))))
        }
}
