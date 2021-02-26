//
//  EntryViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 29/01/2021.
//

import Foundation
import UIKit
import Firebase

class EntryViewController : UIViewController {
    
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ConfirmEntryButton(_ sender: UIButton) {
        if (listName.text! != "") {
            print(listName.text!)
            var ref: DocumentReference? = nil
            ref = db.collection("list").addDocument(data: [
                "title": listName.text!,
                "date": Date(),
                "createdBy": loggedUser,
                "users": [loggedUser]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            return
        }
    }
    
}
