//
//  AppDelegate.swift
//  Scratch
//
//  Created by Richard Stockdale on 25/01/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Cocoa
import HotKey
import Fabric
import Crashlytics


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let hotKey = HotKey(key: .s, modifiers: [.control, .option, .command]) // Setup hot key for ⌥⌘S

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
        Fabric.with([Crashlytics.self])


        setupStatusBarButton()
        setupClickEventMonitor()
        
        // Monitor for hotkey use
        hotKey.keyDownHandler = {
            self.togglePopover(self)
        }
    }
    
    private func setupStatusBarButton() {
        // Create the status bar button
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("statusBarIcon"))
            
            // Show the pop over
            button.action = #selector(togglePopover(_:))
            popover.contentViewController = CurrentNoteViewController.newCurrentNoteController()
        }
    }
    
    private func setupClickEventMonitor() {
        // Montor for click events outside the window. Then close it
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
}

// Popover control
extension AppDelegate {
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}
