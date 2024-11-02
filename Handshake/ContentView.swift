//
//  ContentView.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bleManager = BLEManager()
//    @StateObject private var 
    
    var body: some View {
        SignUp()
    }
}
