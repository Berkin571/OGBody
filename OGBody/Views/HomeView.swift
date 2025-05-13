//
//  HomeView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("White").ignoresSafeArea()
            VStack(spacing: 40) {
                Text("OG Body")
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(Color("PrimaryGreen"))

                VStack(spacing: 20) {
                    NavigationLink {
                        OnboardingView()
                    } label: {
                        Label("Loslegen", systemImage: "figure.walk")
                            .font(.title2.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    NavigationLink {
                        HealthDashboardView()
                    } label: {
                        Label("Health-Dashboard", systemImage: "heart")
                            .font(.title3.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("PrimaryGreen"), lineWidth: 2)
                            )
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                    
                    NavigationLink {
                        SavedPlansView()
                    } label: {
                        Label("Gespeicherte Pläne", systemImage: "bookmark.fill")
                            .font(.title3.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("PrimaryGreen"), lineWidth: 2)
                            )
                            .foregroundColor(Color("PrimaryGreen"))
                    }

                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
