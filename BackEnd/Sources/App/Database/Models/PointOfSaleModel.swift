//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent
import Vapor

final class PointOfSaleModel: Model {
    static let schema = "points_of_sale"
    
    @ID(key: .id)
    var id: UUID?
    
    init() { }
    
    init(id: UUID) {
        self.id = id
    }
}

class PointOfSaleModelMapper {
    static func transform(_ entityDB: PointOfSaleModel?) -> PointOfSale? {
        guard let entityDB = entityDB,
              let id = entityDB.id
        else { return nil }
        
        return PointOfSale(id: id)
    }
}
