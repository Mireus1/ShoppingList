//
//  TemplateModel.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 01/03/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Template: Codable, Identifiable {
    @DocumentID var id: String?
    var createdBy: String
    var title : String
    var users : [String]
}   
