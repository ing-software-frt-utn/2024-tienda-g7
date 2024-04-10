//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation
import Vapor

protocol ProductRepositoryProtocol {
    func save(_ entity: Product, req: Request) async throws
    func get(id: UUID, req: Request) async throws -> Product?
    func update(_ entity: Product, req: Request) async throws
    func delete(_ entity: Product, req: Request) async throws
}

protocol ClientRepositoryProtocol {
    func save(_ entity: inout Client, req: Request) async throws
    func get(documentNumber: String, req: Request) async throws -> Client?
}

protocol PointOfSaleRepositoryProtocol {
    func get(id: UUID, req: Request) async throws -> PointOfSale?
}

protocol OrderRepositoryProtocol {
    func save(_ entity: inout Order, req: Request) async throws
    func update(_ entity: Order, req: Request) async throws
    func get(id: UUID, req: Request) async throws -> Order?
}

protocol ArticleRepositoryProtocol {
    func getAll(req: Request) async throws -> [Article]
    func get(id: UUID, req: Request) async throws -> Article?
}
