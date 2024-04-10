//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent

struct CreateSalesLines: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("sales_lines")
            .id()
            .field("quantity", .int, .required)
            .field("product_id", .uuid, .required, .references("products", "id"))
            .field("order_id", .uuid, .references("orders", "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("sell_lines").delete()
    }
}
