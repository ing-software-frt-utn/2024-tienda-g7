//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

struct BrandController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let articles = routes.grouped("brands")
        articles.get(use: index)
    }
    
    // GET /brands
    func index(req: Request) async throws -> [BrandModel] {
        try await BrandModel.query(on: req.db).all()
    }
}
