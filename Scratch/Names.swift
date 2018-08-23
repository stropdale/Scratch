//
//  NSStoryboardExtension.swift
//  Scratch
//
//  Created by Richard Stockdale on 31/01/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Foundation
import Cocoa

extension NSStoryboard.Name {
    
    /// The main storyboard
    static let mainStoryBoard = NSStoryboard.Name(rawValue: "Main")
}

extension NSStoryboard.SceneIdentifier {
    
    /// Preferences Window Controller
    static let preferencesWindowController = NSStoryboard.SceneIdentifier(rawValue: "PreferencesWindowController")
    
    /// The preferences root view controller
    static let peferencesViewController = NSStoryboard.SceneIdentifier(rawValue: "PreferencesViewController")
}

extension Notification.Name {
    static let preferencesChanged = Notification.Name(rawValue: "preferencesChanged")
}
