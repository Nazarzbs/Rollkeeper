//
//  RollResult.swift
//  Rollkeeper
//
//  Created by Nazar on 28/9/24.
//

import Foundation

class RollResult: Codable, Equatable {
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
    
    static func == (lhs: RollResult, rhs: RollResult) -> Bool {
        lhs.id == rhs.id
    }
}
