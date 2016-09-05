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
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let appearances: [String] = ["Dark", "Light"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appearance: Int? = userDefaults.objectForKey("appearance") as! Int?
        var time: String? = (userDefaults.objectForKey("time") as! String?)!
        var position: Int? = userDefaults.objectForKey("position") as! Int?
        var spaces: Int? = userDefaults.objectForKey("spaces") as! Int?
        
        if appearance == nil {
            appearance = 0
            userDefaults.setObject(appearance, forKey: "appearance")
        }
        
        if time == nil {
            time = "5"
            userDefaults.setObject(time, forKey: "time")
        }
        
        if position == nil {
            position = 0
            userDefaults.setObject(position, forKey: "position")
        }
        
        if spaces == nil {
            spaces = 0
            userDefaults.setObject(position, forKey: "spaces")
        }
        
        appearancePopUp.removeAllItems()
        appearancePopUp.addItemsWithTitles(appearances)
        appearancePopUp.selectItemAtIndex(appearance!)
        timeTextField.stringValue = String(time!)
        positionCheckBox.state = position!
        spacesCheckBox.state = spaces!
    }
    
    @IBAction func popUpSelected(sender: AnyObject) {
        print(appearancePopUp.indexOfSelectedItem)
        save()
    }
    
    @IBAction func timeTextFieldChanged(sender: AnyObject) {
        print(timeTextField.stringValue)
        let time = Int(timeTextField.stringValue)
        if time != nil {
            save()
        } else {
            error("There was a problem.", text: "Make sure you enter an integer. Please try again.")
        }
    }
    
    @IBAction func positionCheckBoxChanged(sender: AnyObject) {
        print(positionCheckBox.state)
        save()
    }
    
    @IBAction func spacesCheckBoxChanged(sender: AnyObject) {
        print(spacesCheckBox.state)
        save()
    }
    
    func save() {
        let appearance = appearancePopUp.indexOfSelectedItem
        let time = timeTextField.stringValue
        let position = positionCheckBox.state
        let spaces = spacesCheckBox.state
        
        userDefaults.setObject(appearance, forKey: "appearance")
        userDefaults.setObject(time, forKey: "time")
        userDefaults.setObject(position, forKey: "position")
        userDefaults.setObject(spaces, forKey: "spaces")
        userDefaults.synchronize()
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
