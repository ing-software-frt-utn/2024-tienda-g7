//
//  Payment.swift
//  Articles
//
//  Created by Esteban Sánchez on 07/03/2024.
//

import Foundation

enum PaymentType: String, CaseIterable, Codable {
    case cash = "Cash"
    case debitCard = "Debit card"
    case creditCard = "Credit card"
}

struct Payment: Codable {
    var type: PaymentType
    var cardInfo: CardInfo
    
    init(type: PaymentType = .cash, cardInfo: CardInfo = CardInfo()) {
        self.type = type
        self.cardInfo = cardInfo
    }
}

struct CardInfo: Codable {
    var cardNumber: String = ""
    var cardHolderName: String = ""
    var cardExpirationMonth: String = ""
    var cardExpirationYear: String = ""
    var cardSecurityNumber: String = ""
    var cardHolderDocument: String = ""
}
