//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class Color: Codable {
    var id: UUID?
    var name: String
    var hexCode: String
    
    init(id: UUID? = nil, name: String, hexCode: String) {
        self.id = id
        self.name = name
        self.hexCode = hexCode
    }
}
