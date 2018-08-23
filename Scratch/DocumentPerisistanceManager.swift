//
//  DocumentPerisistanceManager.swift
//  Scratch
//
//  Created by Richard Stockdale on 30/01/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Foundation

class DocumentPerisistanceManager {
    public static let shared = DocumentPerisistanceManager()
    
    private let tempSaveKey = "TempSaveKey"
    private var lastChange: Date = Date()
    
    private var latestString: String?
    private var lastSavedString: String?
    
    private var timer: Timer?
    
    public var currentText: String {
        get {
            
            // If we dont have the latest string used stored localy, then load it or set it
            guard let latest = self.latestString else {
                if let latest = UserDefaults.standard.object(forKey: tempSaveKey) {
                    latestString = (latest as! String)
                    return latestString!
                }
                
                latestString = ""
                return latestString!
            }
            
            // Otherwise return the latest string
            return latest
        }
        set {
            // Set this the first time
            if self.lastSavedString == nil {
                self.lastSavedString = newValue
            }
            
            lastChange = Date()
            latestString = newValue
            
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { runningTimer in
                    self.updateIfChanges()
                })
            }
        }
    }
    
    private func updateIfChanges() {
        print("Updating string changes= \(String(describing: latestString)) \(String(describing: lastSavedString))")
        if latestString != lastSavedString {
            saveChanges()
            lastSavedString = latestString
        }
    }
    
    public func saveChanges() {
        
        // Tempory saving solution
        UserDefaults.standard.set(currentText, forKey: tempSaveKey)
        UserDefaults.standard.synchronize()
        
    }
}
