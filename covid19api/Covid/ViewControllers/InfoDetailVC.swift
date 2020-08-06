//
//  InfoDetailVC.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import UIKit

class InfoDetailVC: UIViewController {
    // MARK: IBOutlets
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var activeLabel: UILabel!
    @IBOutlet var deathLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var incidentRateLabel: UILabel!
    @IBOutlet var mortalityRateLabel: UILabel!
    @IBOutlet var requestPush: UISwitch!
    
    // MARK: Variables
    var attribute: Attribute?
    
    // MARK: Object life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let attr = self.attribute {
            self.updateUI(attr)
        }
    }
    
    @IBAction func requestPush(_ sender: UISwitch) {
        guard let name = attribute?.country_Region else {return}
        if sender.isOn == true {
            UserDefaults.standard.setValue(name, forKey: name)
        }else{
            UserDefaults.standard.removeObject(forKey: name)
        }
        UserDefaults.standard.synchronize()
    }
}

// MARK: Class methods
extension InfoDetailVC {
    func updateUI(_ attribute: Attribute) {
        if let name = attribute.country_Region {
            countryLabel.text = "Country/Region: \(name)"
            if let _ = UserDefaults.standard.value(forKey: name) {
                requestPush.isOn = true
            }else{
                requestPush.isOn = false
            }
        }
        if let active = attribute.active {
            activeLabel.attributedText = "Active: ".createTitle(value: "(\(active.format()))", color: .purple)
        }
        if let deaths = attribute.deaths {
            deathLabel.attributedText = "Deaths: ".createTitle(value: "(\(deaths.format()))", color: .red)
        }
        if let recovered = attribute.recovered {
            recoveredLabel.attributedText = "Recovered: ".createTitle(value: "(\(recovered.format()))", color: .green)
        }
        if let rate = attribute.incident_Rate {
            incidentRateLabel.text = "Incident Rate: (\(rate))"
        }
        if let rate = attribute.mortality_Rate {
            mortalityRateLabel.text = "Mortality Rate: (\(rate))"
        }
    }
}
