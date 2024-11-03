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
    
    @Published var name: String {
        didSet {
            if let sharedDefaults = UserDefaults(suiteName: "group.com.ptstudios.handshake") {
                sharedDefaults.set(self.name, forKey: ObservableDefaults.nameRoute)
            }
        }
    }

    init() {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.ptstudios.handshake") {
            self.name = sharedDefaults.string(forKey: ObservableDefaults.nameRoute) ?? ""
        } else {
            self.name = ""
        }
    }
    
    static let nameRoute = "name"
}
