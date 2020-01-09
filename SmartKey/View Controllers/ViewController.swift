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
        //overrideUserInterfaceStyle = .dark
        
        // Do any additional setup after loading the view.
        
        if (Auth.auth().currentUser != nil) {
            DispatchQueue.main.async {
                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UINavigationController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }

}

