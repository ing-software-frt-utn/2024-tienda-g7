//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent
import Vapor

final class PaymentModel: Model {
    static let schema = "payments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Field(key: "amount")
    var amount: Double
    
    @Field(key: "type")
    var type: String
    
    init() { }
    
    init(id: UUID? = nil, createdAt: Date? = nil, amount: Double, type: String) {
        self.id = id
        self.createdAt = createdAt
        self.amount = amount
        self.type = type
    }
}

