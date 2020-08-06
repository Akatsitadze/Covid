//
//  Extension-ViewController.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/6/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import UIKit


extension UIViewController {
    func alert(title: String) {
        let alert = UIAlertController(title: "Ooops", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
