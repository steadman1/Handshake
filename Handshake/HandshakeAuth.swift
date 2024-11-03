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
    static let shared = AuthViewModel()
    
    @Published var isAuthenticated = false
    @Published var verificationID: String?
    @Published var isVerificationSent = false
    @Published var authError: String?

    init() {
        // Restore verificationID if available
        verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        isVerificationSent = (verificationID != nil)
    }

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
                
                // Save verificationID to UserDefaults
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
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
                
                // Clear verificationID from UserDefaults after successful sign-in
                UserDefaults.standard.removeObject(forKey: "authVerificationID")
                self?.isAuthenticated = true
            }
        }
    }
}
