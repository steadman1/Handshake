//
//  Bluetooth.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import Foundation
import CoreBluetooth
import UserNotifications

struct DiscoveredDevice: Identifiable {
    let id: UUID
    var name: String
    let identifier: UUID
    var user: User?
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    private let serviceUUID = CBUUID(string: "1234")
    @Published var discoveredDevices: [DiscoveredDevice] = []
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
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
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func startAdvertising() {
        guard peripheralManager.state == .poweredOn else {
            print("Peripheral manager is not powered on")
            return
        }
        let advertisementData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: ObservableDefaults.shared.userId
        ]
        
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let deviceName = peripheral.name ?? "Unknown Device"
        let newDevice = DiscoveredDevice(id: UUID(), name: deviceName, identifier: peripheral.identifier, user: nil)
        
        if !discoveredDevices.contains(where: { $0.identifier == newDevice.identifier }) {
            DispatchQueue.main.async {
                self.discoveredDevices.append(newDevice)
            }
        }
    }
    
    // MARK: - CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertising()
        }
    }
}
