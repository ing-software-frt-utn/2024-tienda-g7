//
//  Receipt.swift
//  Articles
//
//  Created by Esteban Sánchez on 07/03/2024.
//

import Foundation

enum ReceiptType: String, CaseIterable, Codable {
    case bill = "Factura"
    case ticket = "Ticket"
}

struct Receipt: Codable {
    var type: ReceiptType
    var sections: [Section]
    
    init(type: ReceiptType, sections: [Section]) {
        self.type = type
        self.sections = sections
    }
    
    struct Section: Codable {
        var title: String
        var items: [Field]
    }
    
    struct Field: Codable {
        var key: String
        var value: String
    }
}
