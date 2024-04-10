//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class Product: Codable {
    var id: UUID?
    var stock: Int
    var color: Color
    var size: Size
    var price: Double
    var description: String
    var articleID: UUID
    
    init(id: UUID? = nil, stock: Int, color: Color, size: Size, price: Double, description: String, articleID: UUID) {
        self.id = id
        self.stock = stock
        self.color = color
        self.size = size
        self.price = price
        self.description = description
        self.articleID = articleID
    }
}
