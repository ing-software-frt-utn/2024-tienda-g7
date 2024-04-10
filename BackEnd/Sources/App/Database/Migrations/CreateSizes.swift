//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Fluent

struct CreateSizes: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("sizes")
            .id()
            .field("name", .string, .required)
            .field("type", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("sizes").delete()
    }
}
