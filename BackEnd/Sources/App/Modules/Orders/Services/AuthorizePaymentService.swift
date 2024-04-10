//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 03/03/2024.
//

import Foundation
import Vapor
import Fluent

protocol AuthorizePaymentServiceProtocol {
    func getToken(paymentDTO: CreateOrderDTO.Payment, req: Request) async throws -> AuthorizePaymentDTO.TokenResponse
    func authorize(with token: String, bin: String, amount: Double, req: Request) async throws -> AuthorizePaymentDTO.AuthorizeResponse
}

class AuthorizePaymentService: AuthorizePaymentServiceProtocol {
    
    func getToken(paymentDTO: CreateOrderDTO.Payment, req: Request) async throws -> AuthorizePaymentDTO.TokenResponse {
        guard let cardInfo = paymentDTO.cardInfo else {
            throw CustomError.error(message: "Card info not found", status: .badRequest)
        }
        
        let body = AuthorizePaymentDTO.TokenRequest(card_number: cardInfo.cardNumber,
                                                    card_expiration_month: cardInfo.cardExpirationMonth,
                                                    card_expiration_year: cardInfo.cardExpirationYear,
                                                    security_code: cardInfo.cardSecurityNumber,
                                                    card_holder_name: cardInfo.cardHolderName,
                                                    card_holder_identification: .init(type: "dni", number: cardInfo.cardHolderDocument))
        LogHelper.printJson(body)
        let response = try await req.client.post(URI(string: AuthorizePaymentServiceConstants.getTokenURL),
                                                 headers: AuthorizePaymentServiceConstants.getTokenHeaders,
                                                 content: body)
        LogHelper.printJson(response, req: req)
        
        return try response.content.decode(AuthorizePaymentDTO.TokenResponse.self)
    }
    
    func authorize(with token: String, bin: String, amount: Double, req: Request) async throws -> AuthorizePaymentDTO.AuthorizeResponse {
        let body = AuthorizePaymentDTO.AuthorizeRequest(site_transaction_id: UUID().uuidString,
                                                        payment_method_id: 1,
                                                        token: token,
                                                        bin: bin,
                                                        amount: Int(amount),
                                                        currency: "ARS",
                                                        installments: 1,
                                                        description: "",
                                                        payment_type: "single",
                                                        establishment_name: "single",
                                                        sub_payments: [
                                                            .init(site_id: "",
                                                                  amount: Int(amount),
                                                                  installments: nil)
                                                        ])
        LogHelper.printJson(body)
        
        let response = try await req.client.post(URI(string: AuthorizePaymentServiceConstants.authorizeURL),
                                                 headers: AuthorizePaymentServiceConstants.authorizeHeaders,
                                                 content: body)
        LogHelper.printJson(response, req: req)
        return try response.content.decode(AuthorizePaymentDTO.AuthorizeResponse.self)
    }
}
