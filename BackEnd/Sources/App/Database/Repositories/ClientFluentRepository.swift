//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 15/03/2024.
//

import Foundation
import Vapor
import Fluent

final class ClientFluentRepository: ClientRepositoryProtocol {
    func save(_ entity: inout Client, req: Request) async throws  {
        let entityDB = ClientModel(documentNumber: entity.documentNumber,
                                   cuit: entity.cuit,
                                   socialReason: entity.socialReason,
                                   homeAddress: entity.homeAddress,
                                   tributaryCondition: entity.tributaryCondition.rawValue)
        try await entityDB.save(on: req.db)
        entity.id = entityDB.id
    }
    
    func get(documentNumber: String, req: Request) async throws -> Client? {
        guard let entityDB = try await ClientModel.query(on: req.db)
            .filter(\.$documentNumber == documentNumber)
            .first(),
              let tributaryCondition = TributaryCondition(rawValue: entityDB.tributaryCondition)
        else { return nil }
        
        let entity = Client(id: entityDB.id,
                            documentNumber: entityDB.documentNumber,
                            cuit: entityDB.cuit,
                            socialReason: entityDB.socialReason,
                            homeAddress: entityDB.homeAddress,
                            tributaryCondition: tributaryCondition)
        return entity
    }
}
