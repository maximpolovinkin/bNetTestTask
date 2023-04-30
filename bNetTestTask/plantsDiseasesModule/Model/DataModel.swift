//
//  DataModel.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 29.04.2023.
//

import Foundation

struct initial: Codable {
    var products: [drug]
}

struct drug: Codable {
    var id: Int?
    var image: String?
    var categories: categories?
    var name: String?
    var description: String?
}

struct categories: Codable {
    var id: Int?
    var icon: String?
    var image: String?
    var name: String?
}
