//
//  SignUpViewController.swift
//  SmartKey
//
//  Created by alumno on 25/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var rootRef = Database.database().reference()
    
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
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        // TODO: not done
        
        return nil
    }
    
    func showError(_ message: String) {
        self.errorLabel.text = message
        self.errorLabel.alpha = 1
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        // Validate the fields
        let error = validateFields()
        if error != nil {
            // There is something wrong with the fields, show error message
            showError(error!)
        } else {
            // Create cleaned versions of the data
            let name = self.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for error
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                } else {
                    // User was created successfully, now store the name
                    // MARK: hacer callback
                    self.rootRef.child("users").child(result!.user.uid).setValue(["name": name, "email": email]) { (error, result)  in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                        
                }
            }
            
        }
        
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? UINavigationController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
