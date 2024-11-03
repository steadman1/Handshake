//
//  ContentView.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var defaults = ObservableDefaults.shared
    @StateObject private var authViewModel = AuthViewModel.shared
    
    @State private var isNewUser = true
    
    var body: some View {
        if authViewModel.isAuthenticated {
            if isNewUser {
                GetToKnow(isUserNotCreated: $isNewUser)
                    .onAppear {
                        isNewUser = defaults.userId.isEmpty
                    }
            } else {
                Home()
                    .environmentObject(defaults)
            }
        } else {
            SignUp(authViewModel: authViewModel)
        }
    }
}

#Preview {
    ContentView()
}
