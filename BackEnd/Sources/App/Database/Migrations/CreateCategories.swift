//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent

struct CreateCategories: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("categories")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("categories").delete()
    }
}
