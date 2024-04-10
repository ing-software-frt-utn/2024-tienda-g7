//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

final class BrandModel: Content, Model {
    static let schema = "brands"
    
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

class BrandModelMapper {
    static func transform(_ entity: BrandModel) -> Brand {
        Brand(id: entity.id, name: entity.name)
    }
    
    static func transform(_ entity: Brand) -> BrandModel {
        BrandModel(id: entity.id, name: entity.name)
    }
}
