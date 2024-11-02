//
//  AuthViewModel.swift
//  Handshake
//
//  Created by Alex Sleptsov on 11/2/24.
//

import FirebaseCore
import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var verificationID: String?
    @Published var isVerificationSent = false
    @Published var authError: String?

    func sendVerificationCode(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.authError = error.localizedDescription
                    print("Error sending verification code: \(error.localizedDescription)")
                    return
                }
                self?.verificationID = verificationID
                self?.isVerificationSent = true
            }
        }
    }

    func verifyCode(verificationCode: String) {
        guard let verificationID = verificationID else { return }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.authError = error.localizedDescription
                    print("Error verifying code: \(error.localizedDescription)")
                    return
                }
                self?.isAuthenticated = true
            }
        }
    }
}

