//
//  RegionCell.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import UIKit

class RegionCell: UICollectionViewCell {
    @IBOutlet var infoLabel: UILabel!
    
    func configure(_ attribute: Attribute) {
        guard let confirmed = attribute.confirmed else {
            return
        }
        guard let country_Region = attribute.country_Region else {
            return
        }
        guard let recovered = attribute.recovered else {
            return
        }
        guard let deaths = attribute.deaths else {
            return
        }
        infoLabel.attributedText = "\(confirmed.format()) ".createTitle(country_Region: "\(country_Region)", recovered: " (\(recovered.format()))", deaths: " (\(deaths.format()))")
    }
}
