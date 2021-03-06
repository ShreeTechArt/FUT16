//
//  ViewController.swift
//  FUT16
//
//  Created by Konstantin Klitenik on 12/15/15.
//  Copyright © 2015 Kon. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var authTextField: NSTextField!
    
    @IBOutlet weak var secretAnswerTextField: NSTextField!
    
    @IBOutlet weak var typeSegment: NSSegmentedControl!
    
    @IBOutlet weak var playerIdTextField: NSTextField!
    @IBOutlet weak var nationalityComboBox: NSComboBox!
    @IBOutlet weak var leagueComboBox: NSComboBox!
    @IBOutlet weak var teamComboBox: NSComboBox!
    @IBOutlet weak var levelComboBox: NSComboBox!
    @IBOutlet weak var minBinTextField: NSTextField!
    @IBOutlet weak var maxBinTextField: NSTextField!
    @IBOutlet weak var buyAtTextField: NSTextField!
    @IBOutlet weak var breakEvenTextField: NSTextField!
    
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var submitButton: NSButton!
    
    private let fut16 = FUT16()
    var autoTrader: AutoTrader!
    dynamic var traderStats = TraderStats()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        autoTrader = AutoTrader(fut16: fut16, update: {
            self.traderStats = self.autoTrader.stats
        })
        
        updateFieldsStateForSearchType(typeSegment.selectedLabel())
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getIdFromComboBox(comboBox: NSComboBox) -> String? {
        if comboBox.stringValue == "Any" {
            return ""
        }
        
        if comboBox == levelComboBox {
            return comboBox.stringValue
        } else {
            // assuming format is "Label: ID"
            let comps = comboBox.stringValue.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ": "))
            return comps.last
        }
    }

// MARK: UI Actions
    @IBAction func loginPressed(sender: NSButton) {
        fut16.login(emailTextField.stringValue, password: passwordTextField.stringValue, secretAnswer: secretAnswerTextField.stringValue)
    }
    
    @IBAction func submitPressed(sender: NSButton) {
        fut16.sendAuthCode(authTextField.stringValue)
    }
    
    @IBAction func setSearchParamsPressed(sender: NSButton) {
        // Ribery 156616 (43.5k)
        // Neuer 167495 (75k)
        // Martial 211300
        // Tévez 143001
        // Benzema 165153
        // Ramos 155862
        // Alves 146530 (13k)
        
        let nationality = getIdFromComboBox(nationalityComboBox) ?? ""
        let league = getIdFromComboBox(leagueComboBox) ?? ""
        let team = getIdFromComboBox(teamComboBox) ?? ""
        let level  = getIdFromComboBox(levelComboBox) ?? ""
        
        let minSearchBin = UInt(minBinTextField.integerValue)
        let maxSearchBin = UInt(maxBinTextField.integerValue)
        let buyAtBin = UInt(buyAtTextField.integerValue)
        
        var params: FUT16.ItemParams!
        
        switch typeSegment.selectedLabel() {
        case "Player":
            let playerId = playerIdTextField.stringValue
            params = FUT16.PlayerParams(playerId: playerId, nationality: nationality, league: league, team: team, level: level, minBin: minSearchBin, maxBin: maxSearchBin)
        case "Fitness":
            params = FUT16.ConsumableParams(category: "fitness", level: level, minBin: minSearchBin, maxBin: maxSearchBin)
        case "Manager":
            break
        default:
            break
        }
        
        let breakEvenPrice = autoTrader?.setTradeParams(params, buyAtBin: buyAtBin)
        breakEvenTextField.integerValue = Int(breakEvenPrice!)
    }
    
    @IBAction func typeSegmentChanged(sender: NSSegmentedControl) {
        updateFieldsStateForSearchType(sender.selectedLabel())
    }
    
    func updateFieldsStateForSearchType(type: String) {
        // enable all and then disabled necessary fields based on type
        playerIdTextField.enabled = true
        playerIdTextField.enabled = true
        teamComboBox.enabled = true
        leagueComboBox.enabled = true
        nationalityComboBox.enabled = true
        
        switch type {
        case "Player":
            break
        case "Fitness":
            playerIdTextField.enabled = false
            teamComboBox.enabled = false
            leagueComboBox.enabled = false
            nationalityComboBox.enabled = false
        case "Manager":
            playerIdTextField.enabled = false
        default:
            break
        }
    }
    
    @IBAction func doStuffPressed(sender: NSButton) {
        setSearchParamsPressed(sender)
        autoTrader?.startTrading()
    }
    
    @IBAction func stopPressed(sender: NSButton) {
        autoTrader?.stopTrading("UI")
    }
    
    @IBAction func resetStatsPressed(sender: NSButton) {
        autoTrader?.resetStats()
    }
}

extension NSSegmentedControl {
    func selectedLabel() -> String {
        return self.labelForSegment(self.selectedSegment) ?? ""
    }
}

