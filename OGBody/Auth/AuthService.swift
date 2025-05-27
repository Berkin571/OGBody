//
//  AuthService.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//

import FirebaseAuth


final class AuthService {
    static let shared = AuthService()
    private init() {}
    func signUp(email: String, password: String) async throws -> User {
        try await Auth.auth().createUser(withEmail: email, password: password).user
    }
    func signIn(email: String, password: String) async throws -> User {
        try await Auth.auth().signIn(withEmail: email, password: password).user
    }
    func signOut() throws { try Auth.auth().signOut() }
}
