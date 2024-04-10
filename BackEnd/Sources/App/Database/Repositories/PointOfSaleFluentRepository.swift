//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 15/03/2024.
//

import Foundation
import Vapor
import Fluent

final class PointOfSaleFluentRepository: PointOfSaleRepositoryProtocol {
    func get(id: UUID, req: Request) async throws -> PointOfSale? {
        guard let entityDB = try await PointOfSaleModel.find(id, on: req.db)
        else { return nil }
        
        let entity = PointOfSale(id: id)
        return entity
    }
}
