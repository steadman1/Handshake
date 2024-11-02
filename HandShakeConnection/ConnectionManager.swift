import FirebaseFirestore
import FirebaseAuth

class ConnectionManager {
    
    static let shared = ConnectionManager()
    private let db = Firestore.firestore()

    // Sends a connection request to another user
    func requestConnection(with receiverId: String, completion: @escaping (Error?) -> Void) {
        guard let requestorId = Auth.auth().currentUser?.uid else { return }
        let requestId = UUID().uuidString
        let requestData: [String: Any] = [
            "requestor_id": requestorId,
            "receiver_id": receiverId,
            "status": "pending",
        ]
        
        db.collection("ConnectionRequests").document(requestId).setData(requestData) { error in
            completion(error)
        }
    }

    // Approves a connection request
    func approveConnectionRequest(requestId: String, completion: @escaping (Error?) -> Void) {
        db.collection("ConnectionRequests").document(requestId).updateData(["status": "accepted"]) { error in
            completion(error)
        }
    }

    // Listens for user data updates
    func listenForUserDataUpdates(completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Users").document(uid).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else if let data = snapshot?.data() {
                completion(data, nil)
            }
        }
    }
}
