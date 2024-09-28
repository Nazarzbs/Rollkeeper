//
//  RollResult.swift
//  Rollkeeper
//
//  Created by Nazar on 28/9/24.
//

import Foundation
import SwiftData

@Model
class RollResult: Identifiable {
    var id: UUID
    var rollTime: Date
    var rollResult: Int
    var diceNumber: Int
    
    init(id: UUID, rollTime: Date, rollResult: Int, diceNumber: Int) {
        self.id = id
        self.rollTime = rollTime
        self.rollResult = rollResult
        self.diceNumber = diceNumber
    }
}
