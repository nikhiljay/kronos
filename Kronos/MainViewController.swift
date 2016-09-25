//
//  MainViewController.swift
//  Kronos
//
//  Created by Nikhil D'Souza on 9/2/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet var backgroundView: NSVisualEffectView!
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var changeButton: NSButton!
    var timer: Timer = Timer()
    var userDefaults = UserDefaults.standard
    
    var defaultMinutes: Int = 5
    var defaultSeconds: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var state: Bool = false //true = started, false = stopped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance: Int? = userDefaults.object(forKey: "appearance") as! Int?
        let time: String? = (userDefaults.object(forKey: "time") as! String?)!
        
        defaultMinutes = Int(time!)!
        if appearance == 1 {
            backgroundView.material = .light
            timeTextField.textColor = NSColor.black
            titleColor(startStopButton, color: NSColor.white)
            titleColor(changeButton, color: NSColor.white)
        } else {
            backgroundView.material = .dark
            timeTextField.textColor = NSColor.white
        }
        
        backgroundView.state = .active
        
        minutes = defaultMinutes
        seconds = defaultSeconds
        displayTime()
        
        timeTextField.isEditable = false
        timeTextField.isBordered = false
    }
    
    func titleColor(_ button: NSButton, color: NSColor) {
        let color = NSColor.white
        let colorTitle = NSMutableAttributedString(attributedString: button.attributedTitle)
        let titleRange = NSMakeRange(0, colorTitle.length)
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: color, range: titleRange)
        button.attributedTitle = colorTitle
        button.attributedTitle = colorTitle
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground = true
        self.view.window?.titleVisibility = .hidden
        
        //float
        let position: Int? = userDefaults.object(forKey: "position") as! Int?
        if position == 1 {
            self.view.window?.level = Int(CGWindowLevelForKey(.floatingWindow))
            self.view.window?.level =  Int(CGWindowLevelForKey(.maximumWindow))
        }
        
        let spaces: Int? = userDefaults.object(forKey: "spaces") as! Int?
        if spaces == 1 {
            self.view.window?.collectionBehavior = .canJoinAllSpaces
        }
    }

    @IBAction func startStopButtonPressed(_ sender: AnyObject) {
        if state == false {
            displayTime()
            
            if minutes == defaultMinutes && seconds == defaultSeconds {
                minutes -= 1
                seconds = 60
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            
            state = true
        } else {
            timer.invalidate()
            state = false
        }
    }

    func countDown() {
        seconds -= 1
        
        if minutes <= 0 && seconds <= 0 {
            timer.invalidate()
            state = false
            print("done")
        } else if seconds <= 0 {
            minutes -= 1
            seconds = 60
        }

        displayTime()
    }
    
    @IBAction func changeButtonPressed(_ sender: AnyObject) {
        let newString: String = getString("Change the time", question: "Please enter your time in minutes as an integer. (Ex. \"5\" would be 5 minutes.)", defaultValue: "")
        
        if newString != "" {
            let num = Int(newString)
            if num != nil {
                defaultMinutes = num!
                defaultSeconds = 0
                minutes = defaultMinutes
                seconds = defaultSeconds
                
                let updatedMinutes: String = minutes > 9 ? "\(minutes)" : "0\(minutes)"
                let updatedSeconds: String = seconds > 9 ? "\(seconds)" : "0\(seconds)"
                timeTextField.stringValue = "\(updatedMinutes)" + ":" + "\(updatedSeconds)"
                timer.invalidate()
                state = false
            } else {
//                error("There was a problem.", text: "Make sure you enter an integer. Please try again.")
            }
        }
    }
    
    func displayTime() {
        let updatedMinutes: String = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        var updatedSeconds: String = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        if seconds == 60 {
            updatedSeconds = "00"
        }
        timeTextField.stringValue = "\(updatedMinutes)" + ":" + "\(updatedSeconds)"
    }
    
    func getString(_ title: String, question: String, defaultValue: String) -> String {
        let msg = NSAlert()
        msg.addButton(withTitle: "Ok")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = title
        msg.informativeText = question
        
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = defaultValue
        
        msg.accessoryView = txt
        let response: NSModalResponse = msg.runModal()
        
        if (response == NSAlertFirstButtonReturn) {
            return txt.stringValue
        } else if response == NSAlertSecondButtonReturn {
            return ""
        } else {
            return ""
        }
    }
    
    func error(_ question: String, text: String) -> Bool {
        let msg: NSAlert = NSAlert()
        msg.messageText = question
        msg.informativeText = text
        msg.alertStyle = NSAlertStyle.warning
        msg.addButton(withTitle: "Ok")
        return msg.runModal() == NSAlertFirstButtonReturn
    }
    
}

