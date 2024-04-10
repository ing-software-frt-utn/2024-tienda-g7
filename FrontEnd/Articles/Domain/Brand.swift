//
//  Brand.swift
//  Articles
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Foundation

struct Brand: Codable, Hashable, Identifiable {
    let id: UUID
    var name: String
}
