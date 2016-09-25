//
//  PreferencesViewController.swift
//  Kronos
//
//  Created by Nikhil D'Souza on 9/4/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var appearancePopUp: NSPopUpButton!
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var positionCheckBox: NSButton!
    @IBOutlet weak var spacesCheckBox: NSButton!
    
    let userDefaults = UserDefaults.standard
    let appearances: [String] = ["Dark", "Light"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appearance: Int? = userDefaults.object(forKey: "appearance") as! Int?
        var time: String? = (userDefaults.object(forKey: "time") as! String?)!
        var position: Int? = userDefaults.object(forKey: "position") as! Int?
        var spaces: Int? = userDefaults.object(forKey: "spaces") as! Int?
        
        if appearance == nil {
            appearance = 0
            userDefaults.set(appearance, forKey: "appearance")
        }
        
        if time == nil {
            time = "5"
            userDefaults.set(time, forKey: "time")
        }
        
        if position == nil {
            position = 0
            userDefaults.set(position, forKey: "position")
        }
        
        if spaces == nil {
            spaces = 0
            userDefaults.set(position, forKey: "spaces")
        }
        
        appearancePopUp.removeAllItems()
        appearancePopUp.addItems(withTitles: appearances)
        appearancePopUp.selectItem(at: appearance!)
        timeTextField.stringValue = String(time!)
        positionCheckBox.state = position!
        spacesCheckBox.state = spaces!
    }
    
    @IBAction func popUpSelected(_ sender: AnyObject) {
        print(appearancePopUp.indexOfSelectedItem)
        save()
    }
    
    @IBAction func timeTextFieldChanged(_ sender: AnyObject) {
        let time = Int(timeTextField.stringValue)
        if time != nil {
            save()
        } else {
            error("There was a problem.", text: "Make sure you enter an integer. Please try again.")
        }
    }
    
    @IBAction func positionCheckBoxChanged(_ sender: AnyObject) {
        print(positionCheckBox.state)
        save()
    }
    
    @IBAction func spacesCheckBoxChanged(_ sender: AnyObject) {
        print(spacesCheckBox.state)
        save()
    }
    
    func save() {
        let appearance = appearancePopUp.indexOfSelectedItem
        let time = timeTextField.stringValue
        let position = positionCheckBox.state
        let spaces = spacesCheckBox.state
        
        userDefaults.set(appearance, forKey: "appearance")
        userDefaults.set(time, forKey: "time")
        userDefaults.set(position, forKey: "position")
        userDefaults.set(spaces, forKey: "spaces")
        userDefaults.synchronize()
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
