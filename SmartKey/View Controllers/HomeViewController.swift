//
//  HomeViewController.swift
//  SmartKey
//
//  Created by alumno on 25/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    let homeModel = HomeModel()
    var doorList: [Door] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doorList.count // number of rows in section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nuevaCelda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        // MARK: START
        
        DispatchQueue.global().async { [weak self] in
           self!.homeModel.fillArray { (error, array) in
               if(error == false){
                    DispatchQueue.main.async {
                        nuevaCelda.textLabel?.text = array[indexPath.row].name
                        nuevaCelda.detailTextLabel?.text = "Latitud: \(array[indexPath.row].latitude)\nLongitud: \(array[indexPath.row].longitude)"
                        if (array[indexPath.row].open) {
                            nuevaCelda.imageView?.image = UIImage(systemName: "lock.open.fill")
                            nuevaCelda.imageView?.tintColor = UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)                        } else {
                            nuevaCelda.imageView?.image = UIImage(systemName: "lock.fill")
                            nuevaCelda.imageView?.tintColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                        }
                        
                    }
               }
           }
        }
        
        // MARK: END
    
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
    

    

}
