//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class Category: Codable {
    var id: UUID?
    var name: String
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
