//
//  Bluetooth.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import Foundation
import CoreBluetooth
import UserNotifications

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    private let serviceUUID = CBUUID(string: "1234")
    @Published var discoveredDevices: [CBPeripheral] = []
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        // Request permission for notifications
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Central manager is not powered on")
            return
        }
        print("Starting scan...")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScanning() {
        centralManager.stopScan()
        print("Stopped scanning")
    }
    
    func startAdvertising() {
        guard peripheralManager.state == .poweredOn else {
            print("Peripheral manager is not powered on")
            return
        }
        let advertisementData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: "handshake"
        ]
        
        peripheralManager.startAdvertising(advertisementData)
        print("Started advertising with name MyDeviceName")
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        print("Stopped advertising")
    }
    
    func sendDiscoveryNotification(for peripheral: CBPeripheral) {
        let content = UNMutableNotificationContent()
        content.title = "Device Discovered!"
        content.body = "Discovered device: \(peripheral.name ?? "Unknown Device")"
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Central manager state: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered device: \(peripheral.name ?? "Unknown") with RSSI: \(RSSI)")
        
        if !discoveredDevices.contains(peripheral) {
            discoveredDevices.append(peripheral)
            
            // Send a notification when a device is discovered
            sendDiscoveryNotification(for: peripheral)
        }
    }
    
    // MARK: - CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertising()
        } else {
            print("Peripheral manager state: \(peripheral.state.rawValue)")
        }
    }
}
