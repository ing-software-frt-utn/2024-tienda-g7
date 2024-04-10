//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Foundation

enum SizeType: String, Codable {
    case american
    case european
}

final class Size: Codable {
    var id: UUID?
    var name: String
    var type: SizeType
    
    init(id: UUID? = nil, name: String, type: SizeType) {
        self.id = id
        self.name = name
        self.type = type
    }
}
