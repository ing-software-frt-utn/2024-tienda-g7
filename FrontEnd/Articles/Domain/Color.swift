//
//  Color.swift
//  Articles
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Foundation

struct Color: Hashable, Identifiable, Codable {
    let id: UUID?
    var name: String
    var hexCode: String
}
