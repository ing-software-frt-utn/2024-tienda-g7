//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent

struct CreateProducts: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("products")
            .id()
            .field("stock", .int, .required)
            .field("color_id", .uuid, .required, .references("colors", "id"))
            .field("article_id", .uuid, .required, .references("articles", "id"))
            .field("size_id", .uuid, .required, .references("sizes", "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("products").delete()
    }
}
