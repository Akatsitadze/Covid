//
//  Extension-String.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func createTitle(country_Region: String, recovered: String, deaths: String) -> NSAttributedString {
        let description = NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.red,
        ])
        let description2 = NSMutableAttributedString(string: country_Region, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.label,
        ])
        let description3 = NSMutableAttributedString(string: recovered, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.green,
        ])
        let description4 = NSMutableAttributedString(string: deaths, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.red,
        ])
        description.append(description2)
        description.append(description3)
        description.append(description4)
        return description
    }
    
    func createTitle(value: String, color: UIColor) -> NSAttributedString {
        let description = NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.label,
        ])
        let description2 = NSMutableAttributedString(string: value, attributes: [
            NSAttributedString.Key.foregroundColor : color,
        ])
        description.append(description2)
        return description
    }
}
