//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

struct ColorController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let articles = routes.grouped("colors")
        articles.get(use: index)
    }
    
    // GET /colors
    func index(req: Request) async throws -> [ColorModel] {
        try await ColorModel.query(on: req.db).all()
    }
}
