//
//  Extension-Int.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import Foundation

extension Int {
    func format() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) else { return ""}
        return formattedNumber
    }
}
