//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation
import Vapor

enum ReceiptType: String, Codable {
    case bill = "Factura"
    case ticket = "Ticket"
}

enum BillType: String, Codable {
    case A
    case B
}

final class Receipt: Content {
    var id: UUID?
    var type: ReceiptType
    var billType: BillType?
    var sections: [ReceiptSection]
    
    init(id: UUID? = nil, type: ReceiptType) {
        self.id = id
        self.type = type
        self.sections = []
    }
    
    func add(section: ReceiptSection) {
        sections.append(section)
    }
    
    func add(key: String?, value: String?) {
        let section = ReceiptSection(title: "")
        section.add(key: key, value: value)
        sections.append(section)
    }
}

class ReceiptSection: Codable {
    var title: String
    var items: [ReceiptField]
    
    init(title: String) {
        self.title = title
        self.items = []
    }
    
    func add(key: String?, value: String?) {
        guard let key = key, let value = value else { return }
        items.append(ReceiptField(key: key, value: value))
    }
}


struct ReceiptField: Codable {
    var key: String
    var value: String
}
