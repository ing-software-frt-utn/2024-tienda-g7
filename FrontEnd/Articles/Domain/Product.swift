//
//  Product.swift
//  Articles
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Foundation

struct Product: Identifiable, Equatable, Codable {
    let id: UUID
    var color: Color
    var size: Size
    var stock: Int
}
