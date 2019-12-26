//
//  ViewController.swift
//  SmartKey
//
//  Created by alumno on 25/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    let userUid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

