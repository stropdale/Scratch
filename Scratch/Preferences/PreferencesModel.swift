//
//  PreferencesModel.swift
//  Scratch
//
//  Created by Richard Stockdale on 02/02/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Foundation

struct PreferencesModel {
    
    private static let defs = UserDefaults.standard
    private static let iCloudSyncKey = "iCloudSyncKey"
    private static let useMonoSpaceKey = "useMonoSpaceKey"
    private static let useRichTextKey = "useRichTextKey"
    
    static var syncUsingiCloud: Bool {
        get {
            let key = iCloudSyncKey
            if !keyExists(key: key) {
                return false;
            }
            
            return defs.bool(forKey: key)
        }
        
        set {
            defs.set(newValue, forKey: iCloudSyncKey)
            notifyOfChange()
        }
    }
    
    static var useMonoSpace: Bool {
        get {
            let key = useMonoSpaceKey
            if !keyExists(key: key) {
                return false;
            }
            
            return defs.bool(forKey: key)
        }
        
        set {
            defs.set(newValue, forKey: useMonoSpaceKey)
            notifyOfChange()
        }
    }
    
    static var useRichText: Bool {
        get {
            let key = useRichTextKey
            if !keyExists(key: key) {
                return false;
            }
            
            return defs.bool(forKey: key)
        }
        
        set {
            defs.set(newValue, forKey: useRichTextKey)
            notifyOfChange()
        }
    }
    
    private static func notifyOfChange() {
        NotificationCenter.default.post(name: Notification.Name.preferencesChanged, object: nil)
    }
    
    private static func keyExists(key: String) -> Bool {
        if defs.bool(forKey: key) {
            return true
        }
        else {
            return false
        }
    }
}
