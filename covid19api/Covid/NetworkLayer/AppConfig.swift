//
//  AppConfig.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import Foundation

class AppConfig {
    // MARK: - Public Properties
    let BaseUrl: String
    
    // MARK: - Private Properties
    private static var sharedInstance: AppConfig = {
        let shared = AppConfig()
        return shared
    }()
    
    class func shared() -> AppConfig {
        return sharedInstance
    }
    
    // Initialization
    private init() {
        guard let infoPlist = Bundle.main.infoDictionary else {
            fatalError("Somthing wrong with info.plist")
        }
        BaseUrl = infoPlist["BaseUrl"] as! String
    }
}
