//
//  AuthView.swift
//  OGBody
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    
    // MARK: – Form-State
    @State private var email      = ""
    @State private var password   = ""
    @State private var isLogin    = true
    @State private var isSecure   = true
    @State private var isLoading  = false
    @State private var errorMsg:  String?
    
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 6
    }
    
    // MARK: – View
    var body: some View {
        ZStack {
            // Hintergrund-Gradient
            LinearGradient(
                colors: [Color("AccentLight"), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            // Card-Container
            VStack(spacing: 28) {
                
                // Titel
                Text(isLogin ? "Willkommen zurück" : "Account erstellen")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("PrimaryGreen"))
                    .padding(.top, 4)
                
                // Eingabefelder
                VStack(spacing: 18) {
                    inputField(icon: "envelope.fill",
                               placeholder: "E-Mail",
                               text: $email,
                               isSecure: false)
                    
                    inputField(icon: isSecure ? "lock.fill" : "lock.open.fill",
                               placeholder: "Passwort (≥ 6 Zeichen)",
                               text: $password,
                               isSecure: isSecure)
                    .overlay(alignment: .trailing) {
                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(Color("AccentDark"))
                                .padding(.trailing, 14)
                        }
                    }
                }
                
                // Fehlermeldung
                if let errorMsg {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }
                
                // Primär-Button
                Button {
                    Task { await handleEmailAuth() }
                } label: {
                    HStack {
                        if isLoading { ProgressView() }
                        Text(isLogin ? "Einloggen" : "Registrieren")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("PrimaryGreen"))
                .cornerRadius(12)
                .disabled(!isFormValid || isLoading)
                .padding(.top, 6)
                
                // Apple-Button (Pflicht-Look beibehalten)
                SignInWithAppleButton(
                    .signIn,
                    onRequest: authVM.prepareAppleRequest,
                    onCompletion: { res in Task { await handleAppleResult(res) } }
                )
                .frame(height: 36)
                .cornerRadius(12)
                
                // Umschalter
                Button {
                    withAnimation(.easeInOut) {
                        isLogin.toggle()
                        errorMsg = nil
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isLogin ? "Noch keinen Account?" : "Schon registriert?")
                        Text(isLogin ? "Registrieren" : "Einloggen")
                            .foregroundColor(Color("PrimaryGreen"))
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.bottom, 6)
            }
            .padding(28)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .onSubmit { Task { await handleEmailAuth() } }
    }
    
    // MARK: – Reusable Input
    @ViewBuilder
    private func inputField(icon: String,
                            placeholder: String,
                            text: Binding<String>,
                            isSecure: Bool) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color("AccentDark"))
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.9))
        )
    }
    
    // MARK: – Helper
    @MainActor
    private func handleEmailAuth() async {
        guard isFormValid else { return }
        isLoading = true; defer { isLoading = false }
        do {
            if isLogin {
                try await authVM.signIn(email: email, password: password)
            } else {
                try await authVM.signUp(email: email, password: password)
            }
        } catch { errorMsg = error.localizedDescription }
    }
    
    @MainActor
    private func handleAppleResult(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let auth):
            do { try await authVM.signInWithApple(authorization: auth) }
            catch { errorMsg = error.localizedDescription }
        case .failure(let err):
            errorMsg = err.localizedDescription
        }
    }
}
