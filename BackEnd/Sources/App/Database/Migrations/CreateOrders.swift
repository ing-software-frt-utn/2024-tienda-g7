//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent

struct CreateOrders: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("orders")
            .id()
            .field("created_at", .date, .required)
            .field("receipt_id", .uuid, .references("receipts", "id"))
            .field("client_id", .uuid, .references("clients", "id"))
            .field("point_of_sale_id", .uuid, .references("points_of_sale", "id"))
            .field("payment_id", .uuid, .references("payments", "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("orders").delete()
    }
}
