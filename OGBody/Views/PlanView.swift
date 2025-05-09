//
//  PlanView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import SwiftUI

struct PlanView: View {
    @ObservedObject var planVM: PlanViewModel
    var body: some View {
        ScrollView {
            Text(planVM.plan)
                .padding()
                .lineSpacing(6)
        }
        .navigationTitle("Dein Plan")
    }
}
