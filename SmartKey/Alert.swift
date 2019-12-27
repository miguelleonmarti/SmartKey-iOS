//
//  Alert.swift
//  SmartKey
//
//  Created by alumno on 27/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
