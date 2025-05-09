//
//  HomeView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("OG Body")
                .font(.largeTitle).bold()
            NavigationLink("Loslegen", destination: OnboardingView())
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
