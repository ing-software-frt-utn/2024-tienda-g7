//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 13/03/2024.
//

import Foundation
import Vapor

enum GetOrderTotalDTO {
    
    struct Request: Content {
        let salesLines: [SalesLineDTO]
    }
    
    struct Response: Content {
        let total: Double
    }
}
