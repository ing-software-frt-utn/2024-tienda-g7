//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 02/03/2024.
//

import Foundation
import Vapor
import Fluent

enum Constants {
    static let IVA: Double = 0.21
}

enum AuthorizePaymentServiceConstants {
    static let getTokenURL: String = "https://developers.decidir.com/api/v2/tokens"
    static let authorizeURL: String = "https://developers.decidir.com/api/v2/payments?"
    
    static let getTokenHeaders: HTTPHeaders = [
        "apikey": "b192e4cb99564b84bf5db5550112adea",
        "Content-Type": "application/json",
        "Cache-Control": "no-cache"
    ]
    
    static let authorizeHeaders: HTTPHeaders = [
        "apikey": "566f2c897b5e4bfaa0ec2452f5d67f13",
        "Content-Type": "application/json",
        "Cache-Control": "no-cache"
    ]
}

// Define una enumeración para tus tipos de errores personalizados
enum CustomError: AbortError {
    case error(message: String, status: HTTPResponseStatus)
    
    var status: HTTPResponseStatus {
        switch self {
        case .error(_, let status):
            return status
        }
    }
    
    var reason: String {
        switch self {
        case .error(let message, _):
            return message
        }
    }
}
