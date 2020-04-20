//
//  AboutView.swift
//  DarkMode Switcher
//
//  Created by Mohamed Arradi on 6/11/18.
//  Copyright © 2018 Mohamed ARRADI. All rights reserved.
//

import Foundation
import Cocoa

class AboutWindow: NSWindowController {
    
    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appBuildVersionLabel: NSTextField!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("AboutWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titlebarAppearsTransparent =  true
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
       
        guard let releaseVersionNumber = Bundle.main.releaseVersionNumber else {
            return
        }
        
        appBuildVersionLabel.stringValue = "Version \(releaseVersionNumber)"
    }
    
    @IBAction func onViewRepoPressed(_ sender: Any) {
        let url = URL(string: "https://github.com/AngCosmin/airpods-battery")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func onContactPressed(_ sender: Any) {
        guard let service = NSSharingService(named: NSSharingService.Name.composeEmail) else { return }
        service.recipients = ["anghelcosminandrei@gmail.com"]
        service.subject = "AirPods Battery"
        service.perform(withItems: ["Write your content here"])
    }
}
