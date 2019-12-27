//
//  HomeViewController.swift
//  SmartKey
//
//  Created by alumno on 25/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    // Variables
    let homeModel = HomeModel()
    var doorList: [Door] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doorList.count // number of rows in section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nuevaCelda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        DispatchQueue.global().async { [weak self] in
            self!.homeModel.fillArray { (error, array) in
                if(error == false){
                    self!.doorList = array
                    if (indexPath.row < self!.doorList.count) {
                        DispatchQueue.main.async {
                            nuevaCelda.textLabel?.text = self!.doorList[indexPath.row].name
                            nuevaCelda.detailTextLabel?.text = "Latitud: \(self!.doorList[indexPath.row].latitude)\nLongitud: \(self!.doorList[indexPath.row].longitude)"
                            if (self!.doorList[indexPath.row].open) {
                                nuevaCelda.imageView?.image = UIImage(systemName: "lock.open.fill")
                                nuevaCelda.imageView?.tintColor = UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)                        } else {
                                nuevaCelda.imageView?.image = UIImage(systemName: "lock.fill")
                                nuevaCelda.imageView?.tintColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
        
        return nuevaCelda
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        
        // Fill doorList
        homeModel.fillArray { (error, array) in
            if error == false {
                self.doorList = array
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            transitionToMain()
            
        }catch let signOutError as NSError {
            print("Error singin out: %@",signOutError)
        }
    }
    
    func transitionToMain(){
        let mainViewController = storyboard?.instantiateViewController(identifier: "MainVC") as? UINavigationController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! MapViewController
        destination.doorList = self.doorList
        
        
        /*if segue.identifier == "irDetalle" {
            let view = segue.destination as! DetalleViewController
            view.texto = "Hola"
        }*/
    }
        
}
