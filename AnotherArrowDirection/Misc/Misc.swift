//
//  Misc.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import Foundation

func clamp<T: Comparable>(_ value: T, _ min: T, _ max: T) -> T {
    return Swift.min(Swift.max(value, min), max)
}
