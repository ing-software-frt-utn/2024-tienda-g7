//
//  Order.swift
//  Articles
//
//  Created by Esteban Sánchez on 07/03/2024.
//

import Foundation

struct Order: Codable {
    let salesLines: [SalesLine]
    let receiptType: String
    let client: Client
    let pointOfSaleId: String
    var payment: Payment
}
