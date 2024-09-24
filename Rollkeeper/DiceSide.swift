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
    
    static let example = DiceSide(number: 6, degrees: 50, offset: 0, anchor: .leading, rotateHorizontally: true)
}

struct DiceSideView_Previews1: PreviewProvider {
    static var previews: some View {
        DiceSideView(side: DiceSide.example, size: 150)
            .frame(width: 150, height: 150)
            .previewLayout(.sizeThatFits)
    }
}
