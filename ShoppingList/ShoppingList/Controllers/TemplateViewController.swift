//
//  TemplateViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 28/02/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public var TemplateTitle = ""

class TemplateViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var Lists: [String] = []
    
    @IBOutlet weak var TemplateList: UITableView!
    //    private var data = [ShoppingList]()
    
    var templates = [Template]()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TemplateList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.TemplateList.delegate = self
        self.TemplateList.dataSource = self
        self.loadData()
    }
    
    func loadData()
    {
        self.db.collection("template")
            .whereField("createdBy", isEqualTo: loggedUser)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("There is no documents")
                    return
                }
                self.templates = documents.compactMap({ (queryDocumentSnapshot) -> Template? in
                    return try? queryDocumentSnapshot.data(as: Template.self)
                })
                if self.templates.count != 0 {
                    DispatchQueue.main.async {
                        self.TemplateList.reloadData()
                    }
                }
            }
    }
    
    @IBAction func AddListButton(_ sender: UIBarButtonItem) {
        print("New Template")
    
        let alert = UIAlertController(title: "Créer un nouveau template",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Enregistrer",
                                       style: .default)
        {  _ in

            guard let textField = alert.textFields?.first,
            let text = textField.text else { return }
                        
            if (text.isEmpty == false) {
                print(text)
                var ref: DocumentReference? = nil
                ref = self.db.collection("template").addDocument(data: [
                    "title": text,
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
        
        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = templates[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTemplate = templates[indexPath.row].id!
        TemplateTitle = templates[indexPath.row].title
        performSegue(withIdentifier: "GoToTemplateList", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (templates.count > 0) {
                if (templates[indexPath.row].id! != "") {
                    let DeleteElement = templates[indexPath.row].id!
                    print("ELEMENT TO DELETE \(DeleteElement)")
                    db.collection("template").document(DeleteElement).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed! : \(DeleteElement)")
                            print(indexPath.row)
                        }
                    }
                    templates.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}
