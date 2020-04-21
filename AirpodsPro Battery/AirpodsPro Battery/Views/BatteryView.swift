//
//  BatteryViewNew.swift
//  AirpodsPro Battery
//
//  Created by Cosmin Anghel on 20/04/2020.
//  Copyright © 2020 Mohamed Arradi. All rights reserved.
//

import Cocoa

class BatteryView: NSView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var leftBatteryImage: NSImageView!
    @IBOutlet weak var rightBatteryImage: NSImageView!
    @IBOutlet weak var caseBatteryImage: NSImageView!
    @IBOutlet weak var leftBatteryValue: NSTextField!
    @IBOutlet weak var rightBatteryValue: NSTextField!
    @IBOutlet weak var caseBatteryValue: NSTextField!
    @IBOutlet weak var leftBatteryStack: NSStackView!
    @IBOutlet weak var rightBatteryStack: NSStackView!
    @IBOutlet weak var caseBatteryStack: NSStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViewData(_ viewModel: AirPodsBatteryViewModel?) {
        guard let viewModel = viewModel else { return }
        
        leftBatteryValue.stringValue = "\(viewModel.leftBatteryValue) %"
        rightBatteryValue.stringValue = "\(viewModel.rightBatteryValue) %"
        
        if viewModel.caseBatteryValue == 0 {
            caseBatteryValue.stringValue = "Place AirPods\ninside the case"
        } else {
            caseBatteryValue.stringValue = "\(viewModel.caseBatteryValue) %"
        }
        
        leftBatteryStack.isHidden = viewModel.connectionStatus == .connected ? false : true
        rightBatteryStack.isHidden = viewModel.connectionStatus == .connected ? false : true
        caseBatteryStack.isHidden = viewModel.connectionStatus == .connected ? false : true
        titleLabel.stringValue = viewModel.connectionStatus == .connected ? "\(viewModel.deviceName) connected" : "Not connected"
    
        leftBatteryImage.image = getBatteryImage(value: viewModel.leftBatteryValue)
        rightBatteryImage.image = getBatteryImage(value: viewModel.rightBatteryValue)
        caseBatteryImage.image = getBatteryImage(value: viewModel.caseBatteryValue)
    }
    
    private func getBatteryImage(value: Int) -> NSImage? {
        switch value {
        case 1...29: return NSImage(imageLiteralResourceName: "battery/25")
        case 30...59: return NSImage(imageLiteralResourceName: "battery/50")
        case 60...79: return NSImage(imageLiteralResourceName: "battery/75")
        case 80...100: return NSImage(imageLiteralResourceName: "battery/100")
        default: return nil
        }
    }
}
