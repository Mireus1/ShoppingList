//
//  TaskModel.swift
//  ShoppingList
//
//  Created by Remi Poulenard on 28/01/2021.
//

import Foundation

struct Task {
    var id: String = UUID().uuidString
    var title : String
    var completed : Bool
}
