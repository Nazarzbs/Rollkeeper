//
//  RollkeeperApp.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//

import SwiftUI
import SwiftData

@main
struct RollkeeperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RollResult.self)
    }
}
