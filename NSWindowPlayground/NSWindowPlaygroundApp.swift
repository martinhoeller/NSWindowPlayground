//
//  NSWindowPlaygroundApp.swift
//  NSWindowPlayground
//
//  Created by Martin Höller on 26.09.2025.
//

import SwiftUI

@main
struct NSWindowPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}
