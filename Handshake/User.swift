//
//  User.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import Foundation
import SwiftUI

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


