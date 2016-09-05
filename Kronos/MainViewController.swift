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
    var timer: NSTimer = NSTimer()
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var defaultMinutes: Int = 5
    var defaultSeconds: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var state: Bool = false //true = started, false = stopped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance: Int? = userDefaults.objectForKey("appearance") as! Int?
        let time: String? = (userDefaults.objectForKey("time") as! String?)!
        
        defaultMinutes = Int(time!)!
        if appearance == 1 {
            backgroundView.material = .Light
            timeTextField.textColor = NSColor.blackColor()
            titleColor(startStopButton, color: NSColor.whiteColor())
            titleColor(changeButton, color: NSColor.whiteColor())
        } else {
            backgroundView.material = .Dark
            timeTextField.textColor = NSColor.whiteColor()
        }
        
        backgroundView.state = .Active
        
        minutes = defaultMinutes
        seconds = defaultSeconds
        displayTime()
        
        timeTextField.editable = false
        timeTextField.bordered = false
    }
    
    func titleColor(button: NSButton, color: NSColor) {
        let color = NSColor.whiteColor()
        let colorTitle = NSMutableAttributedString(attributedString: button.attributedTitle)
        let titleRange = NSMakeRange(0, colorTitle.length)
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: color, range: titleRange)
        button.attributedTitle = colorTitle
        button.attributedTitle = colorTitle
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.movableByWindowBackground = true
        self.view.window?.styleMask |= NSFullSizeContentViewWindowMask
        self.view.window?.titleVisibility = .Hidden
        
        //float
        let position: Int? = userDefaults.objectForKey("position") as! Int?
        if position == 1 {
            self.view.window?.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
            self.view.window?.level =  Int(CGWindowLevelForKey(.MaximumWindowLevelKey))
        }
        
        let spaces: Int? = userDefaults.objectForKey("spaces") as! Int?
        if spaces == 1 {
            self.view.window?.collectionBehavior = .CanJoinAllSpaces
        }
    }

    @IBAction func startStopButtonPressed(sender: AnyObject) {
        if state == false {
            displayTime()
            
            if minutes == defaultMinutes && seconds == defaultSeconds {
                minutes -= 1
                seconds = 60
            }
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            
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
    
    @IBAction func changeButtonPressed(sender: AnyObject) {
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
                error("There was a problem.", text: "Make sure you enter an integer. Please try again.")
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
    
    func getString(title: String, question: String, defaultValue: String) -> String {
        let msg = NSAlert()
        msg.addButtonWithTitle("Ok")      // 1st button
        msg.addButtonWithTitle("Cancel")  // 2nd button
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
    
    func error(question: String, text: String) -> Bool {
        let msg: NSAlert = NSAlert()
        msg.messageText = question
        msg.informativeText = text
        msg.alertStyle = NSAlertStyle.WarningAlertStyle
        msg.addButtonWithTitle("Ok")
        return msg.runModal() == NSAlertFirstButtonReturn
    }
    
}

