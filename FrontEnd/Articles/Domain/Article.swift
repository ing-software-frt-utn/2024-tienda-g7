//
//  Article.swift
//  Articles
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Foundation

struct Article: Codable, Identifiable {
    let id: UUID
    var name: String
    var price: Double
    var brand: Brand
    var category: Category
    var products: [Product]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.brand = try container.decode(Brand.self, forKey: .brand)
        self.category = try container.decode(Category.self, forKey: .category)
        self.products = try container.decodeIfPresent([Product].self, forKey: .products) ?? []
    }
}
