//
//  PreferencesViewController.swift
//  Scratch
//
//  Created by Richard Stockdale on 31/01/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    //@IBOutlet private weak var syncUsingCloudCheck: NSButton!
    @IBOutlet private weak var useMonoSpaceCheck: NSButton!
    @IBOutlet private weak var allowRichTextCheck: NSButton!
    @IBOutlet weak var versionLabel: NSTextField!
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadPreferences()
        setVersionAndBuild()
    }
    
    private func setVersionAndBuild() {
        guard let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as? String else {
            versionLabel.stringValue = ""
            return
        }
        
        versionLabel.stringValue = "Scratch v" + appVersion + "/" + buildNumber
    }
 
    private func loadPreferences() {
        //syncUsingCloudCheck.state = PreferencesModel.syncUsingiCloud ? .on : .off
        useMonoSpaceCheck.state = PreferencesModel.useMonoSpace ? .on : .off
        allowRichTextCheck.state = PreferencesModel.useRichText ? .on : .off
    }
    
//    @IBAction func CloudSettingChanged(_ sender: NSButton) {
//        print("Cloud")
//        PreferencesModel.syncUsingiCloud = sender.state == .on ? true : false
//    }
    
    @IBAction func monoSpaceSettingChanged(_ sender: NSButton) {
        print("Mono")
        PreferencesModel.useMonoSpace = sender.state == .on ? true : false
    }
    
    @IBAction func richTextSettingChanged(_ sender: NSButton) {
        print("Rich")
        PreferencesModel.useRichText = sender.state == .on ? true : false
    }
    
    
}
