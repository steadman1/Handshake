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
                    self?.connectionError = "Failed to send request: \(error.localizedDescription)"
                } else {
                    self?.connectionStatus = "Request sent successfully"
                }
            }
        }
    }

    // Function to approve a connection
    func approveConnection(requestId: String) {
        ConnectionManager.shared.approveConnectionRequest(requestId: requestId) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.connectionError = "Failed to approve request: \(error.localizedDescription)"
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
                    self?.connectionError = "Failed to fetch user data: \(error.localizedDescription)"
                } else {
                    self?.userData = data
                    self?.connectionStatus = "User data updated"
                }
            }
        }
    }

    // Function to clear status and error messages
    func clearMessages() {
        DispatchQueue.main.async {
            self.connectionStatus = nil
            self.connectionError = nil
        }
    }
}

import SwiftUI

struct ConnectionTestView: View {
    @StateObject private var viewModel = ConnectionViewModel()
    
    // Replace with actual IDs to test
    private let receiverId = "user2UID"    // Replace with a valid receiver UID from Firebase
    private let requestId = "user1UID" // Replace with a valid request document ID from Firebase
    
    var body: some View {
        VStack(spacing: 20) {
            // Display connection status
            if let status = viewModel.connectionStatus {
                Text(status)
                    .foregroundColor(.green)
            }
            
            // Display any error messages
            if let error = viewModel.connectionError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            // Button to send a connection request
            Button("Send Connection Request") {
                viewModel.requestConnection(with: receiverId)
            }
            
            // Button to approve a connection request
            Button("Approve Connection Request") {
                viewModel.approveConnection(requestId: requestId)
            }
            
            // Button to listen for user data updates
            Button("Start Listening for Updates") {
                viewModel.listenForUpdates()
            }
            
            // Display any user data updates
            if let userData = viewModel.userData {
                Text("User Data: \(userData.description)")
                    .padding()
            }
            
            // Clear messages button
            Button("Clear Messages") {
                viewModel.clearMessages()
            }
        }
        .padding()
    }
}

struct ConnectionTestView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionTestView()
    }
}
