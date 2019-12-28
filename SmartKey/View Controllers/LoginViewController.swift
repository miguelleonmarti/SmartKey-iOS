//
//  LoginViewController.swift
//  SmartKey
//
//  Created by alumno on 25/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {self.view.endEditing(true)}
         
    func setUpElements() {
        self.errorLabel.alpha = 0
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // Validate text fields
        
        // Create cleaned versions of the text fields
        let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Signin in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UINavigationController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }

}


