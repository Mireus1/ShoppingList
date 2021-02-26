//
//  ItemModel.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 02/02/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Item : Codable, Identifiable{
    @DocumentID var id: String?
    var addedBy: String
    var title : String
    var completed: Bool
    var listId: String
}
