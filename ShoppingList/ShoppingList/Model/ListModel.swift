//
//  ListModel.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 30/01/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct List: Codable, Identifiable {
    @DocumentID var id: String?
    var createdBy: String
    var date: Date = Date()
    var title : String
    var users : [String]
}
