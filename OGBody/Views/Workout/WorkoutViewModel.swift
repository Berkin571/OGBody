//
//  WorkoutViewModel.swift
//  OGBody
//

import SwiftUI
import Combine

@MainActor
final class WorkoutViewModel: ObservableObject {
    @Published var days: [TrainingDay] = []
    @Published var isLoading = true
    
    private var cancellable: AnyCancellable?
    
    init(repo: WorkoutRepository = .shared) {
        cancellable = repo.$days
            .sink { [weak self] in
                self?.days = $0
                self?.isLoading = false
            }
    }
}
