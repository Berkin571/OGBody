import SwiftUI

@main
struct OGBodyApp: App {
    var body: some Scene {
        WindowGroup(content: {
            // Ein einziger NavigationStack für die gesamte App
            NavigationStack {
                CustomTabBarView { tab in
                    switch tab {
                    case .home:
                        HomeView()
                    case .workout:
                        WorkoutView()
                    case .coach:
                        AIFitnessCoachView()
                    }
                }
            }
        })
    }
}
