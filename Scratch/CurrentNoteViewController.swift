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
    @IBOutlet private weak var shareButton: NSButton!
    @IBOutlet private weak var textView: NSTextView!
    
    private var deletedText: String?
    
    let documentManager = DocumentPerisistanceManager.shared
    
    lazy var preferencesWindowController: PreferencesWindowController = {
        let windowController =  NSStoryboard(name: .mainStoryBoard, bundle: nil).instantiateController(withIdentifier: .preferencesWindowController) as! PreferencesWindowController
        
        return windowController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.sendAction(on: .leftMouseDown)
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
    
    @IBAction func clearDocumentContents(_ sender: Any) {
        if textView.string.isEmpty {
            guard let deletedText = deletedText else {
                textView.string = "Nothing to restore. Tap this button once to delete the document. Tap it again if you made a mistake to restore the document"
                return
            }
            
            textView.string = deletedText
            return
        }
        
        deletedText = textView.string
        textView.string = ""
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

// MARK: Sharing

extension CurrentNoteViewController {
    @IBAction func shareTapped(_ sender: NSButton) {
        let textToShare = getTextToShare()
        
        let sharingPicker = NSSharingServicePicker(items: [textToShare])
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            sharingPicker.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
        })
    }
    
    @IBAction func copyTapped(_ sender: NSButton) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([getTextToShare() as NSPasteboardWriting])
    }
    
    
    /// If no text is selected then returns all text. If text is selected, only the selected text is returned
    ///
    /// - Returns: String
    private func getTextToShare() -> String {
        let ranges = textView.selectedRanges
        var textSelections = String()
        
        for val in ranges {
            if val is NSRange {
               let range = val as! NSRange
                if range.length != 0 {
                    let text = textView.string
                    let indexStartOfText = text.index(text.startIndex, offsetBy: range.location)
                    let indexEndOfText = text.index(text.startIndex, offsetBy: range.location + range.length)
                    
                    let substring = text[indexStartOfText..<indexEndOfText]
                    textSelections.append(String(substring))
                    textSelections.append("\n")
                }
            }
        }
        
        if textSelections.isEmpty {
            return textView.string
        }
        
        return textSelections
    }
}

// MARK: Storyboard instantiation

extension CurrentNoteViewController {
    
    static func newCurrentNoteController() -> CurrentNoteViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "CurrentNoteViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CurrentNoteViewController else {
            fatalError("Why cant i find CurrentNoteViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
