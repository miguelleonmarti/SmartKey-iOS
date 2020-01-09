//
//  NFCViewController.swift
//  SmartKey
//
//  Created by alumno on 27/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit
import CoreNFC

class NFCViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    private var session: NFCNDEFReaderSession?
    let tagSlot: Int = 1 // Tag slot where door identifier is saved
    var doorList: [Door]?
    let homeModel = HomeModel()
    
    func completionHandler(doorState: Bool) -> Void {
        DispatchQueue.main.async {
            let message: String!
            if(doorState) {
                message = "OPEN"
                self.label.textColor = UIColor.green
            } else {
                message = "CLOSED"
                self.label.textColor = UIColor.red
            }
            self.label.text = message
            self.label.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.label.isHidden = true
        }
        
    }
    
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        // Do any additional setup after loading the view.
        self.label.isHidden = true
    }
    
    // When nfc button tapped we read nfc tag, which represents the door
    @IBAction func nfcTapped(_ sender: UIButton) {
        guard NFCNDEFReaderSession.readingAvailable else {
            Alert.showBasicAlert(on: self, with: "Scanning not supported", message: "This device does not support tag scanning.")
            return
        }
        
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.session?.alertMessage = "Hold your iPhone near the door to open/close it."
        self.session?.begin()
    }
    
    // Called when the reader-session expired, you invalidated the dialog or accessed an invalidated session
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
    
    // Called when a new set of NDEF messages is found
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")
        var doorIdentifier: Int?
        for message in messages {
            for record in message.records {
                let payload = (String(data: record.payload, encoding: .utf8)!)
                let text = payload.dropFirst(tagSlot)
                print("Door Identifier (payload): \(text.dropFirst(2))")
                doorIdentifier = Int(text.dropFirst(2))
                print(doorIdentifier!)
            }
        }
        
        // After reading the nfc tag, the nfc session is closed
        self.session?.invalidate()
        self.session = nil
        
        // Check if the current door identifier read from the nfc tag allows to the user
        // If does not it will not change its state and an error message will appear
        if (doorList?.contains(where: { door in door.id == doorIdentifier }))! {
            // User can open/close the door
            homeModel.setDoorState(doorIdentifier: doorIdentifier!, completion: completionHandler)
        } else {
            // Show alert (user does not have permissions to open/close the door)
            DispatchQueue.main.async {
                Alert.showBasicAlert(on: self, with: "Cannot open/close the door", message: "You do not have enough permissions.")
            }
        }
    }

}
