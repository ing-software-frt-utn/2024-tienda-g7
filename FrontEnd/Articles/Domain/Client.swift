//
//  Client.swift
//  Articles
//
//  Created by Esteban Sánchez on 07/03/2024.
//

import Foundation

enum TributaryCondition: String, CaseIterable, Codable {
    case registeredResponsible = "Responsable inscripto"
    case monotributist = "Monotributista"
    case exempt = "Exento"
    case noResponsible = "No responsable"
    case finalConsumer = "Consumidor final"
}

struct Client: Codable {
    var documentNumber: String = ""
    var cuit: String = ""
    var socialReason: String = ""
    var homeAddress: String = ""
    var tributaryCondition: TributaryCondition = .noResponsible
}
