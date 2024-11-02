import Firebase

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var verificationID: String?

    func sendVerificationCode(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error sending verification code: \(error.localizedDescription)")
                return
            }
            self.verificationID = verificationID
        }
    }

    func verifyCode(verificationCode: String) {
        guard let verificationID = verificationID else { return }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Error verifying code: \(error.localizedDescription)")
                return
            }
            self.isAuthenticated = true
        }
    }
}
