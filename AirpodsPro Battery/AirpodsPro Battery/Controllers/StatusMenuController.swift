//
//  ViewController.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Cocoa
import IOBluetooth

fileprivate enum MenuItemTypePosition: Int {
    case batteryView = 0
    case airpodsConnect = 2
    case about = 4
    case refreshDevices = 6
    case quitApp = 8
}

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var batteryView: BatteryView!
    
    var statusMenuItem: NSMenuItem!
    lazy var airpodsBatteryViewModel: AirPodsBatteryViewModel = AirPodsBatteryViewModel()
    
    private var timer: Timer?
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let tickingInterval: TimeInterval = 30
    
    private lazy var aboutView: AboutWindow = {
        return AboutWindow()
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupStatusMenu()
        setUpRecurrentChecks()
               
        updateBatteryValue()
        NotificationCenter.default.addObserver(self, selector: #selector(detectChange), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoTimer), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
    }
    
    fileprivate func setUpRecurrentChecks() {
        
        timer = Timer.scheduledTimer(
            timeInterval: tickingInterval,
            target: self,
            selector: #selector(updateBatteryValue),
            userInfo: nil,
            repeats: true
        )
    }
    
    fileprivate func updateStatusButtonImage(hide: Bool = false) {
        if !hide {
            let icon = NSImage(imageLiteralResourceName: "StatusIconDisconnected")
            icon.isTemplate = true
            statusItem.button?.image = icon
        } else {
            let icon = NSImage(imageLiteralResourceName: "StatusIcon")
            icon.isTemplate = true
            statusItem.button?.image = icon
        }
        
        statusItem.button?.imagePosition = NSControl.ImagePosition.imageRight
    }
    
    fileprivate func setupStatusMenu() {
        guard statusMenu != nil else { return }
        
        updateStatusButtonImage()
        
        statusItem.menu = statusMenu
        
        statusMenuItem = statusMenu.item(at: MenuItemTypePosition.batteryView.rawValue)
        statusMenuItem.view = batteryView
    }
    
    @objc fileprivate func detectChange() {
        setUpRecurrentChecks()
        updateBatteryValue()
    }
    
    @objc fileprivate func undoTimer() {
        updateBatteryValue()
    }

    @objc fileprivate func updateBatteryValue() {
        airpodsBatteryViewModel.updateBatteryInformation { [weak self] (success, connectionStatus) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.batteryView.updateViewData(self.airpodsBatteryViewModel)
                self.statusItem.button?.title = self.airpodsBatteryViewModel.displayStatusMessage

                let pairedDevicesConnected = self.airpodsBatteryViewModel.connectionStatus == .connected
                self.updateStatusButtonImage(hide: pairedDevicesConnected)
            }
        }
    }
    
    // MARK: IBAction
    
    @IBAction func linkToAirpods(_ sender: NSMenuItem) {
        airpodsBatteryViewModel.toogleCurrentBluetoothDevice()
        updateBatteryValue()
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func refreshDevices(_ sender: NSMenuItem) {
        updateBatteryValue()
    }
    
    @IBAction func aboutAppClicked(_ sender: NSMenuItem) {
        aboutView.showWindow(nil)
    }
    
    @IBAction func onAboutPressed(_ sender: Any) {
        aboutView.showWindow(nil)
    }
    
    @IBAction func onQuitPressed(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
