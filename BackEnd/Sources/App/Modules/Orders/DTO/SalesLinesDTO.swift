//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 13/03/2024.
//

import Foundation
import Vapor

struct SalesLineDTO: Codable {
    let quantity: Int
    let productId: String
}
