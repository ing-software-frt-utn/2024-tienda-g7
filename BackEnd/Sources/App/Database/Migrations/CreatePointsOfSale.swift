//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent

struct CreatePointOfSales: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("points_of_sale")
            .id()
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("points_of_sale").delete()
    }
}
