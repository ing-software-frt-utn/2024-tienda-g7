//
//  Size.swift
//  Articles
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Foundation

enum SizeType: String, Codable {
    case american
    case european
}

struct Size: Hashable, Identifiable, Codable {
    let id: UUID?
    var name: String
    var type: SizeType
}
