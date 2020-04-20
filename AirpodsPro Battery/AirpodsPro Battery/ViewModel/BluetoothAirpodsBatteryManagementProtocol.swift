//
//  BluetoothAirpodsBatteryManagementProtocol.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 17/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

enum AirpodsConnectionStatus {
    case connected
    case disconnected
}

protocol BluetoothAirpodsBatteryManagementProtocol {
    
    var connectionStatus: AirpodsConnectionStatus { get set }
    var leftBatteryValue: Int { get set }
    var rightBatteryValue: Int { get set }
    var caseBatteryValue: Int { get set }
    var displayStatusMessage: String { get set }
    var deviceName: String { get }
    var deviceAddress: String { get }
    
    func updateBatteryInformation(completion: @escaping (_ success: Bool, _ connectionStatus: AirpodsConnectionStatus) -> Void)
    func processBatteryEntries(groups: [String])
    func fetchAirpodsName(completion: @escaping (_ deviceName: String,_ deviceAddress: String) -> Void)
    func isAppleDevice(deviceAddress: String, completion: @escaping(_ isApple: Bool) -> Void)
    func toogleCurrentBluetoothDevice()
}
