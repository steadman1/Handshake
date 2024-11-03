//
//  User.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

class User: ObservableObject, Decodable, Identifiable {
    let id: UUID = UUID()
    @Published var name: String
    @Published var phoneNumber: String
    @Published var bio: String
    @Published var interests: [String]
    @Published var songs: [String]
    @Published var handshakeCard: HandshakeCard
    @Published var instagram: String
    @Published var snapchat: String
    @Published var other: String

    init(
        name: String,
        phoneNumber: String,
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

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.interests = try container.decode([String].self, forKey: .interests)
        self.songs = try container.decode([String].self, forKey: .songs)
        self.handshakeCard = try container.decode(HandshakeCard.self, forKey: .handshakeCard)
        self.instagram = try container.decode(String.self, forKey: .instagram)
        self.snapchat = try container.decode(String.self, forKey: .snapchat)
        self.other = try container.decode(String.self, forKey: .other)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, phoneNumber, bio, interests, songs, handshakeCard, instagram, snapchat, other
    }

    class HandshakeCard: ObservableObject, Decodable {
        @Published var design: Int
        @Published var color: String

        init(design: Int, color: String) {
            self.design = design
            self.color = color
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.design = try container.decode(Int.self, forKey: .design)
            self.color = try container.decode(String.self, forKey: .color)
        }
        
        private enum CodingKeys: String, CodingKey {
            case design, color
        }
    }

    static let blank = User(
        name: "",
        phoneNumber: ObservableDefaults.shared.phoneNumber,
        bio: "",
        interests: [],
        songs: [],
        handshakeCard: HandshakeCard(design: 0, color: "#FFFFFF"),
        instagram: "",
        snapchat: "",
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
            "interests": interests as Array<String>,
            "songs": songs as Array<String>,
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
            let url = URL(string: "\(CONSTANTS.endpoint)/auth/signup")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
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
                    
                    // Parse the response data for user_id
                    if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let userId = jsonResponse["user_id"] as? String {
                                
                                DispatchQueue.main.async {
                                    ObservableDefaults.shared.userId = userId
                                }
                            } else {
                                print("User ID not found in the response.")
                            }
                        } catch {
                            print("Error parsing JSON response: \(error.localizedDescription)")
                        }
                    }
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
