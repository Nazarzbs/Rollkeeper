//
//  User.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//
import Foundation

struct User: Equatable, Codable {
    var name: String
    var data: [Int: [Int]]
    
    static let usersExample: [User] = [
        User(
            name: "Andrés",
            data: [
                1 : [4, 1, 6, 2],
                2 : [2, 7, 8],
                4 : [4, 9, 16, 24],
            ]
        ),
        User(name: "Natalia", data: [Int : [Int]]())
    ]
    
    static func ==(lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name
    }
}
