//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

enum PaymentType: String, Codable {
    case cash = "Cash"
    case debitCard = "Debit card"
    case creditCard = "Credit card"
}

final class Payment {
    var id: UUID?
    var createdAt: Date?
    var amount: Double
    var type: PaymentType
    
    init(id: UUID? = nil, createdAt: Date? = nil, amount: Double, type: PaymentType) {
        self.id = id
        self.createdAt = createdAt
        self.amount = amount
        self.type = type
    }
}
