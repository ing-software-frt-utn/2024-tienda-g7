//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent

struct CreateColors: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("colors")
            .id()
            .field("name", .string, .required)
            .field("hexCode", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("colors").delete()
    }
}
