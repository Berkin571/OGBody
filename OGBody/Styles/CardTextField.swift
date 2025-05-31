//
//  CardTextField.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 01.06.25.
//


import SwiftUI

// MARK: – Text-Input-Style
struct CardTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
            )
    }
}
extension View {
    func cardField() -> some View { modifier(CardTextField()) }
}

// MARK: – Primär-Button
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("PrimaryGreen"))
                    .opacity(configuration.isPressed ? 0.7 : 1)
            )
            .foregroundColor(Color("White"))
            .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: – Sekundär-Link-Button
struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minHeight: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("AccentDark").opacity(0.3))
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
            )
            .foregroundColor(Color("AccentDark"))
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
