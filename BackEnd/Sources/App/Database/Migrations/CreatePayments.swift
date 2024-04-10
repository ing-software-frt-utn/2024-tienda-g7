//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent

struct CreatePayments: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("payments")
            .id()
            .field("created_at", .date, .required)
            .field("amount", .double, .required)
            .field("type", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("products").delete()
    }
}
