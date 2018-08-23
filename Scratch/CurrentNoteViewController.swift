//
//  CurrentNoteViewController.swift
//  Scratch
//
//  Created by Richard Stockdale on 28/01/2018.
//  Copyright © 2018 Junction Seven. All rights reserved.
//

import Cocoa

class CurrentNoteViewController: NSViewController {

    @IBOutlet private weak var settingsButton: NSButton!
    @IBOutlet private var textView: NSTextView!
    let documentManager = DocumentPerisistanceManager.shared
    
    lazy var preferencesWindowController: PreferencesWindowController = {
        let windowController =  NSStoryboard(name: .mainStoryBoard, bundle: nil).instantiateController(withIdentifier: .preferencesWindowController) as! PreferencesWindowController
        
        return windowController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(prefsDidChange), name: Notification.Name.preferencesChanged, object: nil)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let text = textView.textStorage?.string else {
            return
        }
        
        NSApplication.shared.mainWindow?.makeFirstResponder(textView)
        textView.setSelectedRange(NSMakeRange(text.count, 0))
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        DocumentPerisistanceManager.shared.saveChanges()
        
    }
    
    @objc private func prefsDidChange() {
        setupTextView()
    }
    
    private func setupTextView() {
        if PreferencesModel.useMonoSpace {
            textView.font = NSFont(name: "Menlo", size: 16)
        }
        else {
            textView.font = NSFont.systemFont(ofSize: 16)
        }
        
        textView.textContainerInset = NSSize(width: 10, height: 10)
        textView.isRichText = PreferencesModel.useRichText
        textView.delegate = self
        textView.string = documentManager.currentText
        
        // TODO: Mono Spacing
    }
    
    @IBAction func toggleSettingsMenu(_ sender: Any) {
        if let event = NSApplication.shared.currentEvent {
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Preferences", action: #selector(showPreferences), keyEquivalent: ","))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            NSMenu.popUpContextMenu(menu, with: event, for: settingsButton)
        }
    }
    
    @objc private func showPreferences() {
        preferencesWindowController.showWindow(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CurrentNoteViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView,
                  shouldChangeTextIn affectedCharRange: NSRange,
                  replacementString: String?) -> Bool {
        
        // The string will be nil if the user is trying to apply a styling. We dont what them to do this unless they're using rich text
        if PreferencesModel.useRichText == false && replacementString == nil {
            return false
        }
       
        guard let textValue = textView.textStorage?.string else {
            return true
        }
        
        documentManager.currentText = textValue
        
        return true
    }
}

extension CurrentNoteViewController {
    // MARK: Storyboard instantiation
    static func newCurrentNoteController() -> CurrentNoteViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "CurrentNoteViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CurrentNoteViewController else {
            fatalError("Why cant i find CurrentNoteViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
