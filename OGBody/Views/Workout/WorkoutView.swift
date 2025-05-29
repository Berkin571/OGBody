//
//  WorkoutView.swift
//  OGBody
//

import SwiftUI

struct WorkoutView: View {
    @StateObject private var vm = WorkoutViewModel()
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            Group {
                switch (vm.isLoading, vm.days.isEmpty) {
                case (true, _):
                    ProgressView("Lade Plan …")
                    
                case (false, true):
                    VStack(spacing: 24) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 60))
                            .foregroundColor(Color("PrimaryGreen"))
                        Text("Kein Trainingsplan vorhanden")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        NavigationLink("Perfekt abgestimmten Plan generieren") {
                            OnboardingView()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("PrimaryGreen"))
                    }
                    .padding()
                    
                default:
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.days) { day in
                                NavigationLink {
                                    WorkoutDetailView(day: day)
                                } label: {
                                    WorkoutCardView(day: day)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
            .navigationTitle("Workout")
        }
    }
}
