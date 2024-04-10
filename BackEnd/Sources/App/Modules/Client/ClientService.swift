//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 03/03/2024.
//

import Foundation
import Vapor
import Fluent

protocol ClientServiceProtocol {
    func createIfNeeded(_ clientDTO: CreateOrderDTO.Client, req: Request) async throws -> Client
}

class ClientService: ClientServiceProtocol {
    var repository: ClientRepositoryProtocol
    
    init(repository: ClientRepositoryProtocol) {
        self.repository = repository
    }
    
    func createIfNeeded(_ clientDTO: CreateOrderDTO.Client, req: Request) async throws -> Client {
        if let client = try await repository.get(documentNumber: clientDTO.documentNumber, req: req)
        {
            return client
            
        } else if let tributaryCondition = TributaryCondition(rawValue: clientDTO.tributaryCondition) {
            var client = Client(documentNumber: clientDTO.documentNumber,
                                cuit: clientDTO.cuit,
                                socialReason: clientDTO.socialReason,
                                homeAddress: clientDTO.homeAddress,
                                tributaryCondition: tributaryCondition)
            try await repository.save(&client, req: req)
            return client
            
        } else {
            throw(Abort(.notAcceptable))
        }
    }
}
