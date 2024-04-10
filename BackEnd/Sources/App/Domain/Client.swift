//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

enum TributaryCondition: String, Codable {
    case registeredResponsible = "Responsable inscripto"
    case monotributist = "Monotributista"
    case exempt = "Exento"
    case noResponsible = "No responsable"
    case finalConsumer = "Consumidor final"
}

final class Client {
    var id: UUID?
    var documentNumber: String
    var cuit: String
    var socialReason: String
    var homeAddress: String
    var tributaryCondition: TributaryCondition
    
    init(id: UUID? = nil, documentNumber: String, cuit: String, socialReason: String, homeAddress: String, tributaryCondition: TributaryCondition) {
        self.id = id
        self.documentNumber = documentNumber
        self.cuit = cuit
        self.socialReason = socialReason
        self.homeAddress = homeAddress
        self.tributaryCondition = tributaryCondition
    }
}
