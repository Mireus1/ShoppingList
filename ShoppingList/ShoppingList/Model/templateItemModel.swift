//
//  templateItemModel.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 03/03/2021.
//

import Foundation

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TemplateItem : Codable, Identifiable{
    @DocumentID var id: String?
    var addedBy: String
    var title : String
    var templateID: String
}
