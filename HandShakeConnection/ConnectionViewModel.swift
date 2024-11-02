import SwiftUI
import FirebaseAuth

class ConnectionViewModel: ObservableObject {
    
    @Published var connectionStatus: String? = nil
    @Published var connectionError: String? = nil
    @Published var userData: [String: Any]? = nil

    // Function to request a connection
    func requestConnection(with receiverId: String) {
        ConnectionManager.shared.requestConnection(with: receiverId) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.connectionError = error.localizedDescription
                } else {
                    self?.connectionStatus = "Request sent"
                }
            }
        }
    }

    // Function to approve a connection
    func approveConnection(requestId: String) {
        ConnectionManager.shared.approveConnectionRequest(requestId: requestId) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.connectionError = error.localizedDescription
                } else {
                    self?.connectionStatus = "Connection approved"
                }
            }
        }
    }

    // Function to listen for user data updates
    func listenForUpdates() {
        ConnectionManager.shared.listenForUserDataUpdates { [weak self] data, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.connectionError = error.localizedDescription
                } else {
                    self?.userData = data
                }
            }
        }
    }
}
