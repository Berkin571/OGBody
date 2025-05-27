//
//  OGBodyApp.swift
//  OGBody
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct OGBodyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel()          
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
        }
    }
    
    // MARK: – Root-Weiche
    @ViewBuilder
    private func RootView() -> some View {
        if authVM.isChecking {
            ProgressView("Lade …")
        } else if authVM.user != nil {
            NavigationStack {
                CustomTabBarView { tab in
                    switch tab {
                    case .home:      HomeView()
                    case .workout:   WorkoutView()
                    case .coach:     AIFitnessCoachView()
                    case .settings:  SettingsView()
                    }
                }
            }
        } else {
            AuthView()
        }
    }
}
