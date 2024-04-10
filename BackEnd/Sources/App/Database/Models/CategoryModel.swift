//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

final class CategoryModel: Content, Model {
    static let schema = "categories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

class CategoryModelMapper {
    static func transform(_ entity: CategoryModel) -> Category {
        Category(id: entity.id, name: entity.name)
    }
    
    static func transform(_ entity: Category) -> CategoryModel {
        CategoryModel(id: entity.id, name: entity.name)
    }
}
