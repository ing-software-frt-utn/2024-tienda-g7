//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 02/03/2024.
//

import Foundation
import Vapor

struct CreateOrderDTO: Content {
    let salesLines: [SalesLineDTO]
    let receiptType: String
    let client: Client?
    let pointOfSaleId: String
    let payment: Payment
    
    struct Payment: Codable {
        let type: String
        let cardInfo: CardInfo?
    }
    
    struct CardInfo: Codable {
        let cardNumber: String
        let cardHolderName: String
        let cardExpirationMonth: String
        let cardExpirationYear: String
        let cardSecurityNumber: String
        let cardHolderDocument: String
    }
    
    struct Client: Codable {
        let documentNumber: String
        let cuit: String
        let socialReason: String
        let homeAddress: String
        let tributaryCondition: String
    }
}
