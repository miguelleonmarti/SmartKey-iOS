//
//  Door.swift
//  SmartKey
//
//  Created by alumno on 26/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import Foundation
import Firebase

struct Door {
    
    let ref: DatabaseReference?
    let key: String
    let id: Int
    let address: String
    let latitude: String
    let longitude: String
    let name: String
    let open: Bool
    let users: [String]
    
     
    
    init(id: Int, address: String, latitude: String, longitude: String, name: String, open: Bool,key:String = "", users: [String]) {
        self.ref = nil
        self.key = key
        self.address = address
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.open = open
        self.users = users
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? Int,
            let address = value["address"] as? String,
            let latitude = value["latitude"] as? String,
            let longitude = value["longitude"] as? String,
            let name = value["name"] as? String,
            let open = value["open"] as? Bool,
            let users = value["users"] as? [String]
            else {return nil}
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.id = id
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.open = open
        self.users = users
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "name": name,
            "open": open,
            "users": users
        ]
    }
}
