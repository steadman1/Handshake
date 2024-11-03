//
//  ObservableDefaults.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import Foundation
import Combine
import UIKit

class ObservableDefaults: ObservableObject {
    static var shared = ObservableDefaults()
    
    @Published var userId: String {
        didSet {
            if let sharedDefaults = UserDefaults(suiteName: "group.com.ptstudios.handshake") {
                sharedDefaults.set(self.userId, forKey: ObservableDefaults.userIdRoute)
            }
        }
    }
    
    @Published var phoneNumber: String {
        didSet {
            if let sharedDefaults = UserDefaults(suiteName: "group.com.ptstudios.handshake") {
                sharedDefaults.set(self.phoneNumber, forKey: ObservableDefaults.phoneNumberRoute)
            }
        }
    }

    init() {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.ptstudios.handshake") {
            self.userId = sharedDefaults.string(forKey: ObservableDefaults.userIdRoute) ?? ""
            self.phoneNumber = sharedDefaults.string(forKey: ObservableDefaults.phoneNumberRoute) ?? ""
        } else {
            self.userId = ""
            self.phoneNumber = ""
        }
    }
    
    static let userIdRoute = "name"
    static let phoneNumberRoute = "phoneNumber"
}
