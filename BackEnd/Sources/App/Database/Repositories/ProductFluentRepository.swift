//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 15/03/2024.
//

import Foundation
import Vapor
import Fluent

final class ProductFluentRepository: ProductRepositoryProtocol {
    func save(_ entity: Product, req: Request) async throws {
        let productDB = ProductModelMapper.transform(entity)
        try await productDB.save(on: req.db)
    }
    
    func get(id: UUID, req: Request) async throws -> Product? {
        guard let entityDB = try await ProductModel.find(id, on: req.db) else { return nil }
        try await entityDB.$color.load(on: req.db)
        try await entityDB.$size.load(on: req.db)
        try await entityDB.$article.load(on: req.db)
        return ProductModelMapper.transform(entityDB)
    }
    
    func update(_ entity: Product, req: Request) async throws {
        guard let entityDB = try await ProductModel.find(entity.id, on: req.db) else {
            throw(Abort(.notFound))
        }
        entityDB.stock = entity.stock
        try await entityDB.update(on: req.db)
    }
    
    func delete(_ entity: Product, req: Request) async throws {
        guard let entityDB = try await ProductModel.find(entity.id, on: req.db) else {
            throw(Abort(.notFound))
        }
        try await entityDB.delete(on: req.db)
    }
}
