//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent

struct CreateReceipts: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("receipts")
            .id()
            .field("type", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("receipts").delete()
    }
}
