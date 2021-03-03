//
//  TemplateListViewController.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 02/03/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TemplateListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TemplateItems: UITableView!
    
    var items = [TemplateItem]()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        TemplateItems.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.TemplateItems.delegate = self
        self.TemplateItems.dataSource = self
        self.loadData()
        self.title = TemplateTitle
    }

    func loadData()
    {
        print("Load items")
        self.db.collection("templateItems")
            .whereField("templateID", isEqualTo: selectedTemplate)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("There is no documents")
                    return
                }
                self.items = documents.compactMap({ (queryDocumentSnapshot) -> TemplateItem? in
                    return try? queryDocumentSnapshot.data(as: TemplateItem.self)
                })
                if self.items.count != 0 {
                    DispatchQueue.main.async {
                        self.TemplateItems.reloadData()
                    }
                }
            }
    }
    
    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        print("add item")

        let alert = UIAlertController(title: "Ajouter un item",
                                      message: "",
                                      preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Enregistrer",
                                       style: .default)
        {  _ in

            guard let textField = alert.textFields?.first,
            let text = textField.text else { return }

            if (text != "") {
                var ref: DocumentReference? = nil
                ref = self.db.collection("templateItems").addDocument(data: [
                    "addedBy": loggedUser,
                    "title": text,
                    "templateID": selectedTemplate
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
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.gray
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

