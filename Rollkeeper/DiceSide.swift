//
//  DiceSide.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//

import SwiftUI

struct DiceSide {
    var number: Int
    var degrees: Double
    var offset: Double
    var anchor: UnitPoint
    var rotateHorizontally: Bool
    
    static let example = DiceSide(number: 6, degrees: 0, offset: 0, anchor: .trailing, rotateHorizontally: true)
}
