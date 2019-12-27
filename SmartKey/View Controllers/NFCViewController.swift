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
    let tagSlot: Int = 5 // Tag slot where door identifier is saved
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nfcTapped(_ sender: UIButton) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.session?.alertMessage = "Hold your iPhone near the item to learn more about it."
        self.session?.begin()
    }
    
    // Called when the reader-session expired, you invalidated the dialog or accessed an invalidated session
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
    
    // Called when a new set of NDEF messages is found
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")
        
        for message in messages {
            for record in message.records {
                let payload = (String(data: record.payload, encoding: .utf8)!)
                let text = payload.dropFirst(tagSlot)
                print("Door Identifier (payload): \(text)")
            }
        }
    }
    
    
    
}
