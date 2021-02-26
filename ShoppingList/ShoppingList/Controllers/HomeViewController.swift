//
//  HomeViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 28/01/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//class ShoppingList {
//    @objc dynamic var list: String = ""
//    @objc dynamic var date: Date = Date()
//}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var Lists: [String] = []
    @IBOutlet weak var TableList: UITableView!
    @IBOutlet weak var AddBarButton: UIBarButtonItem!
    
    private var data = [ShoppingList]()
    
    var lists = [List]()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TableList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.TableList.delegate = self
        self.TableList.dataSource = self
        self.loadData()
    }
    
    func loadData()
    {
        self.db.collection("list")
            .whereField("users", arrayContains: loggedUser)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("There is no documents")
                    return
                }
                self.lists = documents.compactMap({ (queryDocumentSnapshot) -> List? in
                    return try? queryDocumentSnapshot.data(as: List.self)
                })
                if self.lists.count != 0 {
                    DispatchQueue.main.async {
                        self.TableList.reloadData()
                    }
                }
            }
    }
    
    @IBAction func AddListButton(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "GoToNewList", sender: nil)
        print("New List")
    
        let alert = UIAlertController(title: "Créer une nouvelle liste",
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
                ref = self.db.collection("list").addDocument(data: [
                    "title": text,
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
        
        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func GoToListButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToList", sender: nil)
    }
    // Mark: Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedList = lists[indexPath.row].id!
        performSegue(withIdentifier: "GoToList", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (lists[indexPath.row].id! != "") {
                let DeleteElement = lists[indexPath.row].id!
                print("ELEMENT TO DELETE \(DeleteElement)")
                db.collection("list").document(DeleteElement).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed! : \(DeleteElement)")
                        self.lists.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}

