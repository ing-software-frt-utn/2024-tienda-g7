//
//  Category.swift
//  Articles
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Foundation

struct Category: Codable, Hashable, Identifiable {
    let id: UUID
    var name: String
}
