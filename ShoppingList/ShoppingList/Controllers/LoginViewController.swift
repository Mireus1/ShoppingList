//
//  LoginViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 28/01/2021.
//

import Foundation
import UIKit
import Firebase

public var loggedUser = ""

public var selectedList = ""

public var selectedTemplate = ""

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.delegate = self
        self.user.becomeFirstResponder()
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        print(user.text!)
        print(password.text!)
        
        if (user.text != "" && password.text != "") {
            let userRef = db.collection("users")
            userRef.whereField("username", isEqualTo: user.text!).whereField("password", isEqualTo: password.text!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            loggedUser = self.user.text!
                            self.performSegue(withIdentifier: "GoToHome", sender: nil)
                        }
                    }
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        print("Sign Up button tapped!")
        performSegue(withIdentifier: "GoToSignUp", sender: self)
    }
}
