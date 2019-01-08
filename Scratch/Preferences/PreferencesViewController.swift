//
//  PreferencesViewController.swift
//  Scratch
//
//  Created by Richard Stockdale on 31/01/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Cocoa

// TODO: Need to validate the key combo entries

class PreferencesViewController: NSViewController {

    //@IBOutlet private weak var syncUsingCloudCheck: NSButton!
    @IBOutlet private weak var useMonoSpaceCheck: NSButton!
    @IBOutlet private weak var allowRichTextCheck: NSButton!
    @IBOutlet weak var versionLabel: NSTextField!
    
    // KeyboardShort Cut
    @IBOutlet weak var control: NSButton!
    @IBOutlet weak var option: NSButton!
    @IBOutlet weak var command: NSButton!
    @IBOutlet weak var keyField: NSTextField!
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadPreferences()
        setVersionAndBuild()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        saveShowKeyCombo()
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
        loadShowHotkeyCombo()
    }
    
    private func loadShowHotkeyCombo() {
        let hotkey = HotKeyManager.getShowHotKeyCombo()
        
        control.state = hotkey.isCtrl ? .on : .off
        option.state = hotkey.isOption ? .on : .off
        command.state = hotkey.isCmd ? .on : .off
        
        keyField.stringValue = hotkey.key
    }
    
    private func saveShowKeyCombo() {
        if keyField.stringValue.isEmpty {
            return
        }
        else if control.state == .off && command.state == .off && option.state == .off {
            return
        }
        
        let combo = KeyCombo()
        combo.key = keyField.stringValue
        combo.isCtrl = control.state == .on ? true : false
        combo.isCmd = command.state == .on ? true : false
        combo.isOption = option.state == .on ? true : false
        
        HotKeyManager.setShowHotKeyCombo(keyCombo: combo)
    }
    
//    @IBAction func CloudSettingChanged(_ sender: NSButton) {
//        print("Cloud")
//        PreferencesModel.syncUsingiCloud = sender.state == .on ? true : false
//    }
    
    @IBAction func monoSpaceSettingChanged(_ sender: NSButton) {
        PreferencesModel.useMonoSpace = sender.state == .on ? true : false
    }
    
    @IBAction func richTextSettingChanged(_ sender: NSButton) {
        PreferencesModel.useRichText = sender.state == .on ? true : false
    }
}

extension PreferencesViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        keyField.stringValue = keyField.stringValue.lowercased()
        
        if keyField.stringValue.count > 1 {
            let firstChar = keyField.stringValue.prefix(1)
            keyField.stringValue = String(firstChar)
        }
    }
}
