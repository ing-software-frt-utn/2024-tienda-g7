//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Fluent
import Vapor

final class SizeModel: Model {
    static let schema = "sizes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "type")
    var type: String
    
    init() { }
    
    init(id: UUID? = nil, name: String, type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
}

class SizeModelMapper {
    static func transform(_ entity: SizeModel) -> Size {
        Size(id: entity.id,
             name: entity.name,
             type: SizeType(rawValue: entity.type) ?? .american)
    }
}
