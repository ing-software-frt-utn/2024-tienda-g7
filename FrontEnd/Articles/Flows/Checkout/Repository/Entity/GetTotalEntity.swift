//
//  GetTotalEntity.swift
//  Articles
//
//  Created by Esteban Sánchez on 14/03/2024.
//

import Foundation

enum GetTotal {
    
    struct Request: Codable {
        let salesLines: [SalesLine]
    }
    
    struct Response: Codable {
        let total: Double
    }
}
