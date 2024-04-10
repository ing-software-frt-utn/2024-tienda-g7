//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let articles = routes.grouped("categories")
        articles.get(use: index)
    }
    
    // GET /categories
    func index(req: Request) async throws -> [CategoryModel] {
        try await CategoryModel.query(on: req.db).all()
    }
}
