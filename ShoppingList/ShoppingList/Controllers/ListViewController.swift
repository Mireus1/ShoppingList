//
//  ListViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 29/01/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableItems: UITableView!
    
    var items = [Item]()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        TableItems.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.TableItems.delegate = self
        self.TableItems.dataSource = self
        self.loadData()
    }

    func loadData()
    {
        print("Load items")
        self.db.collection("items")
            .whereField("listId", isEqualTo: selectedList)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("There is no documents")
                    return
                }
                self.items = documents.compactMap({ (queryDocumentSnapshot) -> Item? in
                    return try? queryDocumentSnapshot.data(as: Item.self)
                })
                if self.items.count != 0 {
                    DispatchQueue.main.async {
                        self.TableItems.reloadData()
                    }
                }
            }
    }
    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        print("add item")
    
        let alert = UIAlertController(title: "Ajouter un produit",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Enregistrer",
                                       style: .default)
        {  _ in

            guard let textField = alert.textFields?.first,
            let text = textField.text else { return }
            
            if (text != "") {
                var ref: DocumentReference? = nil
                ref = self.db.collection("items").addDocument(data: [
                    "addedBy": loggedUser,
                    "title": text,
                    "completed": false,
                    "listId": selectedList
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        self.loadData()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func EditUserListButton(_ sender: UIBarButtonItem) {
        print("add user")
    
        let alert = UIAlertController(title: "Ajouter un utilisateur à la liste",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Enregistrer",
                                       style: .default)
        {  _ in

            guard let textField = alert.textFields?.first,
            let text = textField.text else { return }

            if (text.isEmpty == false) {
                print(text)
                self.db.collection("list").document(selectedList).updateData(["users": FieldValue.arrayUnion([text])])
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // Mark: Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (items[indexPath.row].id! != "") {
                let DeleteElement = items[indexPath.row].id!
                db.collection("items").document(DeleteElement).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                        return
                    } else {
                        print("Document successfully removed! : \(DeleteElement)")
                    }
                }
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
