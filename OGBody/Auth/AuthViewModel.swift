//
//  AuthViewModel.swift
//  OGBody
//

import FirebaseAuth
import AuthenticationServices
import CryptoKit
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    
    // Auth-State
    @Published var user: FirebaseAuth.User?
    @Published var isChecking = true          // Splash-Loader
    
    private var listener: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?         // für Apple-Login
    
    // ---------------------------------------------------------------- init
    init() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isChecking = false
        }
    }
    deinit {
        if let listener { Auth.auth().removeStateDidChangeListener(listener) }
    }
    
    // --------------------------------------------------- Mail / Passwort
    func signIn(email: String, password: String) async throws {
        user = try await AuthService.shared.signIn(email: email, password: password)
    }
    func signUp(email: String, password: String) async throws {
        user = try await AuthService.shared.signUp(email: email, password: password)
    }
    func signOut() throws {
        try AuthService.shared.signOut()
    }
    
    // --------------------------------------------------- Apple-Login
    /// Vorbereitung des Apple-Requests (Nonce + Scopes)
    func prepareAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = Self.randomNonce()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = Self.sha256(nonce)
    }
    
    /// Apple-Credential → Firebase-Credential
    func signInWithApple(authorization auth: ASAuthorization) async throws {
        guard
            let appleIDCred = auth.credential as? ASAuthorizationAppleIDCredential,
            let nonce       = currentNonce,
            let tokenData   = appleIDCred.identityToken,
            let tokenString = String(data: tokenData, encoding: .utf8)
        else { throw AppleSignInError.missingNonce }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: tokenString,
            rawNonce: nonce,
            fullName: appleIDCred.fullName
        )
        
        let result = try await Auth.auth().signIn(with: credential)
        self.user = result.user
        self.currentNonce = nil
    }
    
    // --------------------------------------------------- Fehler-Typ
    enum AppleSignInError: LocalizedError {
        case missingNonce
        var errorDescription: String? {
            switch self {
            case .missingNonce: "Interner Fehler: Nonce fehlt – bitte erneut versuchen."
            }
        }
    }
    
    // --------------------------------------------------- Nonce-Helpers
    private static func randomNonce(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result  = ""
        var remaining = length
        
        while remaining > 0 {
            var random: UInt8 = 0
            SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if random < charset.count {
                result.append(charset[Int(random)])
                remaining -= 1
            }
        }
        return result
    }
    
    private static func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
