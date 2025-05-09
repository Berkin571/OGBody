//
//  PlanViewModel.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import Foundation

@MainActor
class PlanViewModel: ObservableObject {
    @Published var plan = ""
    func update(with text: String) { plan = text }
}
