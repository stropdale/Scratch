//
//  HotKeyManager.swift
//  Scratch
//
//  Created by Richard Stockdale on 25/11/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Foundation
import HotKey

class HotKeyManager {
    
    
    /// The hot key key for UserDefaults
    private static let showKeyComboKey = "showKeyComboKey"
    
    // MARK: - Get Key Combo
    public static func getShowHotKeyCombo() -> KeyCombo {
        guard let savedComboData =  UserDefaults.standard.object(forKey: showKeyComboKey) else {
            return KeyCombo()
        }
        
        let savedCombo = NSKeyedUnarchiver.unarchiveObject(with: savedComboData  as! Data) as! KeyCombo

        return savedCombo
    }
    
    // MARK: - Set key combo
    public static func setShowHotKeyCombo(keyCombo: KeyCombo) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: keyCombo)
        UserDefaults.standard.set(encodedData, forKey: showKeyComboKey)
        UserDefaults.standard.synchronize()
        
        // Udpate the listener
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.updateShowKeyComboHandler()
    }
}

class KeyCombo: NSObject, NSCoding {
    
    private let isCtrlKey = "isCtrl"
    private let isOptionKey = "isOption"
    private let isCmdKey = "isCmd"
    private let keyKey = "key"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isCtrl, forKey: isCtrlKey)
        aCoder.encode(isOption, forKey: isOptionKey)
        aCoder.encode(isCmd, forKey: isCmdKey)
        aCoder.encode(key, forKey: keyKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        isCmd = aDecoder.decodeBool(forKey: isCmdKey)
        isOption = aDecoder.decodeBool(forKey: isOptionKey)
        isCtrl = aDecoder.decodeBool(forKey: isCtrlKey)
        
        key = aDecoder.decodeObject(forKey: keyKey) as! String
    }
    
    override init() {}
    
    var isCmd = true
    var isOption = true
    var isCtrl = true
    
    var key = "s"
    
    var getHotKey: HotKey {
        get {
            if key.isEmpty {
                key = "s"
            }
            
            let firstChar = key.prefix(1)
            let keyValue = Key(string: String(firstChar))
            var modiferFlags: NSEvent.ModifierFlags = []
            
            if isCmd {
                modiferFlags.insert(NSEvent.ModifierFlags.command)
            }
            if isCtrl {
                modiferFlags.insert(NSEvent.ModifierFlags.control)
            }
            if isOption {
                modiferFlags.insert(NSEvent.ModifierFlags.option)
            }
            
            let hotKey = HotKey(key: keyValue!, modifiers: modiferFlags)
            return hotKey

        }
    }
}
