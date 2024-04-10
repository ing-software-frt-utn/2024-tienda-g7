//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class Order {
    var id: UUID?
    var createdAt: Date?
    var receipt: Receipt?
    var client: Client?
    var pointOfSale: PointOfSale?
    var payment: Payment?
    var salesLines: [SalesLine]
    
    init(id: UUID? = nil, createdAt: Date? = nil, client: Client? = nil, pointOfSale: PointOfSale?, salesLines: [SalesLine]) {
        self.id = id
        self.createdAt = createdAt
        self.client = client
        self.pointOfSale = pointOfSale
        self.salesLines = salesLines
    }
    
    init(id: UUID? = nil, salesLines: [SalesLine]) {
        self.id = id
        self.salesLines = salesLines
    }
    
    // MARK: - Methods
    
    func getTotal() -> Double {
        let prices: [Double] = salesLines.map { $0.getSubtotal() }
        let total: Double = prices.reduce(0) { $0 + $1 }
        return total
    }
    
    func addProduct(_ product: Product, quantity: Int) {
        let salesLine = SalesLine(quantity: quantity, product: product, order: self)
        self.salesLines.append(salesLine)
    }
    
    func removeProduct(with productId: UUID) {
        guard let index = salesLines.firstIndex(where: { $0.product.id == productId }) else {
            return
        }
        self.salesLines.remove(at: index)
    }
    
    func pay(client: Client?, paymentType: PaymentType) {
        let payment = Payment(amount: getTotal(), type: paymentType)
        self.client = client
        self.payment = payment
    }
    
    func getReceipt(for receiptType: ReceiptType) -> Receipt {
        let receipt = Receipt(type: receiptType)
        
        let informationSection = ReceiptSection(title: "Receipt information")
        
        if let createdAt = createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: createdAt)
            informationSection.add(key: "Date:", value: formattedDate)
        }
        
        if let pointOfSale = pointOfSale {
            informationSection.add(key: "Point of sale", value: pointOfSale.id?.uuidString)
        }
        
        
        switch receiptType {
        case .bill:
            guard let client = client else { return receipt }
            
            switch client.tributaryCondition {
            case .registeredResponsible, .monotributist:
                receipt.billType = .A
                informationSection.add(key: "Receipt Type:", value: "Factura A")
                
            case .exempt, .noResponsible, .finalConsumer:
                receipt.billType = .B
                informationSection.add(key: "Receipt Type:", value: "Factura B")
            }
            
            receipt.add(section: informationSection)
            
            let clientSection = ReceiptSection(title: "Client information")
            clientSection.add(key: "Social Reason", value: client.socialReason)
            clientSection.add(key: "Document number", value: client.documentNumber)
            clientSection.add(key: "CUIT", value: client.cuit)
            clientSection.add(key: "Home address", value: client.homeAddress)
            clientSection.add(key: "Tributary condition", value: client.tributaryCondition.rawValue)
            
            receipt.add(section: clientSection)
            
        case .ticket:
            informationSection.add(key: "Receipt Type:", value: "Ticket")
            receipt.add(section: informationSection)
        }
        
        let salesLineSection = ReceiptSection(title: "Sales lines")
        
        for salesLine in salesLines {
            salesLineSection.add(key: salesLine.product.description, value: "X\(salesLine.quantity) $\(salesLine.getSubtotal())")
        }
        
        receipt.add(section: salesLineSection)
        
        if let payment = payment {
            receipt.add(key: "Total:", value: "$\(payment.amount)")
        }
        
        return receipt
    }
}
