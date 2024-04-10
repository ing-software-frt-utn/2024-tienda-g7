//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent

struct CreateClients: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("clients")
            .id()
            .field("document_number", .string, .required)
            .field("cuit", .string, .required)
            .field("social_reason", .string, .required)
            .field("home_address", .string, .required)
            .field("tributary_condition", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("orders").delete()
    }
}
