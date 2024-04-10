//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent
import Vapor

final class ReceiptModel: Model {
    static let schema = "receipts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Enum(key: "type")
    var type: ReceiptType
    
    init() { }
    
    init(id: UUID? = nil, type: ReceiptType) {
        self.id = id
        self.type = type
    }
}

