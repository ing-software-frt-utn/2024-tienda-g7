//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 05/03/2024.
//

import Foundation
import Vapor
import Fluent

final class OrderFluentRepository: OrderRepositoryProtocol {
    func save(_ entity: inout Order, req: Request) async throws {
        let entityDB = OrderModelMapper.transform(entity)
        try await entityDB.save(on: req.db)
        entity.id = entityDB.id
    }
    
    func get(id: UUID, req: Request) async throws -> Order? {
        let entityDB = try await OrderModel.query(on: req.db)
            .with(\.$receipt)
            .with(\.$client)
            .with(\.$pointOfSale)
            .with(\.$payment)
            .with(\.$salesLines) { $0.with(\.$product) }
            .filter(\.$id == id)
            .first()
        
        return OrderModelMapper.transform(entityDB)
    }
    
    func update(_ entity: Order, req: Request) async throws {
        guard let entityDB = try await OrderModel.find(entity.id, on: req.db) else {
            throw(Abort(.notFound))
        }
        try await entityDB.update(on: req.db)
    }
}
