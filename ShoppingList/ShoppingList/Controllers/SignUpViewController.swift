//
//  SignUpViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 30/01/2021.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        password.textContentType = .oneTimeCode
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.username.becomeFirstResponder()
        self.password.becomeFirstResponder()
    }
    
    @IBAction func confirmSubscribeButton(_ sender: UIButton) {
        if (username.text != "" && password.text != "") {
            print(username.text!)
            print(password.text!)
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "username": username.text!,
                "password": password.text!,
                "id": UUID().uuidString
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
