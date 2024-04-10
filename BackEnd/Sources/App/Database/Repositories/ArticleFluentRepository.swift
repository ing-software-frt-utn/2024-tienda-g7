//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 15/03/2024.
//

import Foundation
import Vapor

class ArticleFluentRepository: ArticleRepositoryProtocol {
    func getAll(req: Request) async throws -> [Article] {
        let entitiesDB = try await ArticleModel.query(on: req.db)
            .with(\.$brand)
            .with(\.$category)
            .with(\.$products) { product in
                product.with(\.$size)
                product.with(\.$color)
                product.with(\.$article)
            }
            .all()
        return ArticleModelMapper.transform(entitiesDB)
    }
    
    func get(id: UUID, req: Request) async throws -> Article? {
        try await getAll(req: req).filter({ $0.id == id }).first
    }
}
