//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent
import Vapor

final class ClientModel: Model {
    static let schema = "clients"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "document_number")
    var documentNumber: String
    
    @Field(key: "cuit")
    var cuit: String
    
    @Field(key: "social_reason")
    var socialReason: String
    
    @Field(key: "home_address")
    var homeAddress: String
    
    @Field(key: "tributary_condition")
    var tributaryCondition: String
    
    init() { }
    
    init(id: UUID? = nil, documentNumber: String, cuit: String, socialReason: String, homeAddress: String, tributaryCondition: String) {
        self.id = id
        self.documentNumber = documentNumber
        self.cuit = cuit
        self.socialReason = socialReason
        self.homeAddress = homeAddress
        self.tributaryCondition = tributaryCondition
    }
}

class ClientModelMapper {
    static func transform(_ entityDB: ClientModel?) -> Client? {
        guard let entityDB = entityDB else { return nil }
        return transform(entityDB)
    }
    
    static func transform(_ entityDB: ClientModel) -> Client {
        return Client(id: entityDB.id,
                      documentNumber: entityDB.documentNumber,
                      cuit: entityDB.cuit,
                      socialReason: entityDB.socialReason,
                      homeAddress: entityDB.homeAddress,
                      tributaryCondition: TributaryCondition(rawValue: entityDB.tributaryCondition) ?? .noResponsible)
    }
}
