//
//  ContentView.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var defaults = ObservableDefaults.shared
    @StateObject private var bleManager = BLEManager()
    @StateObject private var authViewModel = AuthViewModel.shared
    
    @State private var isNewUser = false
    
    var body: some View {
        if authViewModel.isAuthenticated {
            if isNewUser {
                GetToKnow()
            } else {
                Text("test")
            }
        } else {
            SignUp(authViewModel: authViewModel)
                .onAppear {
                    isNewUser = defaults.name.isEmpty
                }
        }
    }
}
