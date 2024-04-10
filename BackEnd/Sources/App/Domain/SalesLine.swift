//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class SalesLine {
    var id: UUID?
    var quantity: Int
    var product: Product
    weak var order: Order?
    
    init(id: UUID? = nil, quantity: Int, product: Product) {
        self.id = id
        self.quantity = quantity
        self.product = product
    }
    
    init(id: UUID? = nil, quantity: Int, product: Product, order: Order?) {
        self.id = id
        self.quantity = quantity
        self.product = product
        self.order = order
    }
    
    // MARK: - Methods
    
    func getSubtotal() -> Double {
        return product.price * Double(quantity)
    }
}
