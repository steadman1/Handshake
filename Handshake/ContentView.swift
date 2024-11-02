//
//  ContentView.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bleManager = BLEManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("BLE Scanning & Advertising")
                    .font(.headline)
                    .padding()
                
                Text("Discovered Devices:")
                    .font(.subheadline)
                    .padding(.top)
                
                List(bleManager.discoveredDevices, id: \.identifier) { peripheral in
                    Text(peripheral.name ?? "Unknown Device")
                }
                
                HStack {
                    Button(action: {
                        bleManager.startScanning()
                    }) {
                        Text("Start Scanning")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        bleManager.stopScanning()
                    }) {
                        Text("Stop Scanning")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top)
                
                HStack {
                    Button(action: {
                        bleManager.startAdvertising()
                    }) {
                        Text("Start Advertising")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        bleManager.stopAdvertising()
                    }) {
                        Text("Stop Advertising")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("BLE Manager")
        }
        .onAppear {
            // Start both scanning and advertising when the view appears
            bleManager.startScanning()
            bleManager.startAdvertising()
        }
        .onDisappear {
            // Stop both scanning and advertising when the view disappears
            bleManager.stopScanning()
            bleManager.stopAdvertising()
        }
    }
}
