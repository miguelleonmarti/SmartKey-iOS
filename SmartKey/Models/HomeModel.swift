//
//  HomeModel.swift
//  SmartKey
//
//  Created by alumno on 26/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class HomeModel {
    var doorList: [Door] = []
    var size: Int?
    var uid: String = Auth.auth().currentUser!.uid
    
    func fillArray(completion: @escaping (Bool, [Door]) -> Void){
        let ref = Database.database().reference().child("doors")
        ref.observe(.value, with: { (snapshot) in
            
            var doorListDummy : [Door] = []
            print(snapshot.value)
        
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let door = Door(snapshot: snapshot){
                    print("Hola carlos y dayron")
                    doorListDummy.append(door)
                }
                print("Holaa")
            }
            
            self.size = doorListDummy.count
            self.doorList = doorListDummy
            print(self.doorList)
            completion(false,self.doorList)
                    
        })
    
    }
}
