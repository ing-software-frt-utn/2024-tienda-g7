//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 03/03/2024.
//

import Foundation
import Fluent
import Vapor

enum AuthorizePaymentDTO {
    
    struct TokenRequest: Content {
        let card_number: String
        let card_expiration_month: String
        let card_expiration_year: String
        let security_code: String
        let card_holder_name: String
        let card_holder_identification: Identification
        
        struct Identification: Codable {
            let type: String
            let number: String
        }
    }
    
    struct TokenResponse: Codable {
        let id: String
        let bin: String
    }
    
    struct AuthorizeRequest: Content {
        let site_transaction_id: String
        let payment_method_id: Int
        let token: String
        let bin: String
        let amount: Int
        let currency: String
        let installments: Int
        let description: String
        let payment_type: String
        let establishment_name: String
        let sub_payments: [Subpayment]
        
        struct Subpayment: Content {
            let site_id: String
            let amount: Int
            let installments: String?
        }
    }
    
    struct AuthorizeResponse: Codable {
        let status: String
        let status_details: StatusDetail
        
        struct StatusDetail: Codable {
            let ticket: String
        }
    }
}
