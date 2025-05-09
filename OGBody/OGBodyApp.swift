//
//  OGBodyApp.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import SwiftUI

@main
struct OGBodyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {                // Neue Navigation API :contentReference[oaicite:5]{index=5}
                HomeView()
            }
        }
    }
}
