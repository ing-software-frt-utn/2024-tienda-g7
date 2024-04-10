//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

final class ColorModel: Content, Model {
    static let schema = "colors"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "hexCode")
    var hexCode: String
    
    init() { }
    
    init(id: UUID? = nil, name: String, hexCode: String) {
        self.id = id
        self.name = name
        self.hexCode = hexCode
    }
}

class ColorModelMapper {
    static func transform(_ entity: ColorModel) -> Color {
        Color(id: entity.id, name: entity.name, hexCode: entity.hexCode)
    }
}
