//
//  WorkoutView.swift
//  OGBody
//
//  Created by You on 15.05.25.
//

import SwiftUI

// PreferenceKey, um den Scroll-Offset zu messen
private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

struct WorkoutView: View {
    private let workouts = WorkoutData.all
    
    // 1× definieren und dann in beiden Grids verwenden
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var showNavTitle = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // ─── Deine ursprüngliche Überschrift & Beschreibung ───
                    Text("Workout")
                        .font(.largeTitle).bold()
                        .foregroundColor(Color("PrimaryGreen"))
                    
                    Text("Hier findest du deine täglichen Trainingspläne.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // ─── Erste Grid-Reihe: Workout-Cards ───
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(workouts) { workout in
                            NavigationLink {
                                WorkoutDetailView(workout: workout)
                            } label: {
                                WorkoutCardView(workout: workout)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // ─── Zweite Grid-Reihe: KI-Plan-Card ───
                    LazyVGrid(columns: columns, spacing: 16) {
                        NavigationLink {
                            OnboardingView()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color("PrimaryGreen").opacity(0.8),
                                            Color("PrimaryGreen").opacity(0.4)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(height: 180)
                                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                    Text("KI-Plan\ngenerieren")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
                .padding(.vertical)
                // ScrollOffset messen, um den NavTitle erst beim Scrollen einzublenden
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: proxy.frame(in: .named("scroll")).minY
                            )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { y in
                withAnimation(.easeInOut) {
                    showNavTitle = (y < -50)
                }
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(!showNavTitle)
        }
    }
}
