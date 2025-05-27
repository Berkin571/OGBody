//
//  SettingsView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        Form {
            Section {
                Button(role: .destructive) {
                    try? authVM.signOut()          // 1-Zeiler genügt
                } label: {
                    Label("Abmelden", systemImage: "power")
                }
            } footer: {
                Text("Du kannst dich jederzeit wieder einloggen.")
            }
        }
        .navigationTitle("Einstellungen")
    }
}
