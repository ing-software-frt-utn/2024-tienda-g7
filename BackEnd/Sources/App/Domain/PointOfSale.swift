//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class PointOfSale {
    var id: UUID?
    
    init() { }
    
    init(id: UUID) {
        self.id = id
    }
    
    // MARK: - Methods
    
    func initSale() -> Order {
        return Order(pointOfSale: self, salesLines: [])
    }
}
