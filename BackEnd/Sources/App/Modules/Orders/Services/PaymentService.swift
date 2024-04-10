//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 03/03/2024.
//

import Foundation
import Fluent
import Vapor

protocol PaymentServiceProtocol {
    func pay(order: inout Order, clientDTO: CreateOrderDTO.Client?, paymentDTO: CreateOrderDTO.Payment, req: Request) async throws
}

class PaymentService: PaymentServiceProtocol {
    let clientService: ClientServiceProtocol
    let authorizePaymentService: AuthorizePaymentServiceProtocol
    let orderRepository: OrderRepositoryProtocol
    
    init(authorizePaymentService: AuthorizePaymentServiceProtocol, clientService: ClientServiceProtocol, orderRepository: OrderRepositoryProtocol) {
        self.authorizePaymentService = authorizePaymentService
        self.clientService = clientService
        self.orderRepository = orderRepository
    }
    
    func pay(order: inout Order, clientDTO: CreateOrderDTO.Client?, paymentDTO: CreateOrderDTO.Payment, req: Request) async throws {
        guard let paymentType = PaymentType(rawValue: paymentDTO.type) else {
            throw CustomError.error(message: "Payment type not valid", status: .badRequest)
        }
        
        switch paymentType {
        case .cash:
            order.pay(client: nil, paymentType: paymentType)
            
        case .debitCard, .creditCard:
            guard let clientDTO = clientDTO else { throw CustomError.error(message: "Client not found", status: .badRequest) }
            
            let client = try await clientService.createIfNeeded(clientDTO, req: req)
            let tokenResponse = try await authorizePaymentService.getToken(paymentDTO: paymentDTO,
                                                                           req: req)
            let response = try await authorizePaymentService.authorize(with: tokenResponse.id,
                                                                       bin: tokenResponse.bin,
                                                                       amount: order.getTotal(),
                                                                       req: req)
            
            guard response.status == "approved" else { throw CustomError.error(message: "Payment not authorized", status: .notAcceptable) }
            
            order.pay(client: client, paymentType: paymentType)
        }
    }
}
