//
//  User.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import Foundation
import SwiftUI
import FirebaseAuth


class User: ObservableObject {
    @Published var name: String
    @Published var phoneNumber: Int
    @Published var bio: String
    @Published var interests: [String]
    @Published var songs: [String]
    @Published var handshakeCard: HandshakeCard
    @Published var instagram: String
    @Published var snapchat: String
    @Published var other: String
    
    init(
        name: String,
        phoneNumber: Int,
        bio: String,
        interests: [String],
        songs: [String],
        handshakeCard: HandshakeCard,
        instagram: String,
        snapchat: String,
        other: String
    ) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.bio = bio
        self.interests = interests
        self.songs = songs
        self.handshakeCard = handshakeCard
        self.instagram = instagram
        self.snapchat = snapchat
        self.other = other
    }
    
    class HandshakeCard: ObservableObject {
        @Published var design: Int // Allowed values: 0, 1, 2, 3
        @Published var color: String // Hex color code, e.g., "#FFFFFF"
        
        init(design: Int, color: String) {
            self.design = design
            self.color = color
        }
    }
    
    static let blank = User(
        name: "spence",
        phoneNumber: 0,
        bio: "",
        interests: [],
        songs: [],
        handshakeCard: HandshakeCard(design: 0, color: "#FFFFFF"),
        instagram: "test",
        snapchat: "test",
        other: ""
    )
}

extension User {
    func toJSON() -> Data? {
        // Convert to a dictionary representation
        let userDict: [String: Any] = [
            "name": name,
            "phoneNumber": phoneNumber,
            "bio": bio,
            "interests": interests,
            "songs": songs,
            "handshakeCard": [
                "design": handshakeCard.design,
                "color": handshakeCard.color
            ],
            "instagram": instagram,
            "snapchat": snapchat,
            "other": other
        ]
        
        // Convert dictionary to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
            return jsonData
        } catch {
            print("Error converting User to JSON: \(error)")
            return nil
        }
    }
    
    func sendToSignupEndpoint() {
        // Ensure the current user is logged in and retrieve the ID token
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        // Get the ID token
        currentUser.getIDToken { [weak self] idToken, error in
            if let error = error {
                print("Error retrieving ID token: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = idToken, let userJSON = self?.toJSON() else {
                print("Failed to get ID token or user JSON.")
                return
            }
            
            // Set up the URL and request
            let url = URL(string: "http://172.18.59.155:8000/auth/signup")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = userJSON
            
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Request error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response received.")
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    print("User successfully sent to signup endpoint.")
                } else {
                    print("Server error: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                }
            }
            
            task.resume()
        }
    }
}
