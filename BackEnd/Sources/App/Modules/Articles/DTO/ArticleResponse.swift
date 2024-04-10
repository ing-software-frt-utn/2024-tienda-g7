//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 15/03/2024.
//

import Foundation
import Vapor

struct ArticleResponse: Content {
    var id: UUID
    var name: String
    var price: Double
    var brand: Brand
    var category: Category
    var products: [Product]
}

class ArticleResponseMapper {
    static func transform(_ entities: [Article]) -> [ArticleResponse] {
        return entities.map({ transform($0) })
    }
    
    static func transform(_ entity: Article) -> ArticleResponse {
        return .init(id: entity.id!,
                     name: entity.name,
                     price: entity.getPrice(),
                     brand: entity.brand,
                     category: entity.category,
                     products: entity.products)
    }
}
