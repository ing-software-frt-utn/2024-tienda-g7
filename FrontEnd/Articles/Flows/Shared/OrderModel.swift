//
//  Order.swift
//  Articles
//
//  Created by Esteban Sánchez on 28/02/2024.
//

import Foundation

class OrderModel: ObservableObject {
    struct Item: Hashable {
        let articleID: UUID?
        let productID: UUID?
        let colorName: String
        let colorHexCode: String
        let description: String
        let size: String
        let price: Double
        let quantity: Int
        var subtotal: Double { price * Double(quantity) }
    }
    
    @Published var items = [Item]()
    @Published var client = Client()
    @Published var payment = Payment()
    @Published var receiptType: ReceiptType = .ticket
    
    @Published var cashAmount: Double = 0.0
    var cashReturn: Double { .maximum(cashAmount - subtotal, 0) }
    
    var subtotal: Double { items.reduce(0.0, { $0 + $1.subtotal }) }
    
    public func add(_ product: Product, from article: Article, quantity: Int) {
        let item = Item(articleID: article.id,
                        productID: product.id,
                        colorName: product.color.name,
                        colorHexCode: product.color.hexCode,
                        description: article.name,
                        size: product.size.name,
                        price: article.price,
                        quantity: quantity)
        items.append(item)
    }
    
    public func remove(articleID: UUID) {
        if let index = items.firstIndex(where: { $0.articleID == articleID }) {
            items.remove(at: index)
        }
    }
    
    public func remove(productID: UUID) {
        if let index = items.firstIndex(where: { $0.productID == productID }) {
            items.remove(at: index)
        }
    }
    
    public func clean() {
        self.items = [Item]()
        self.client = Client()
        self.payment = Payment()
        self.receiptType = .ticket
        self.cashAmount = 0.0
    }
}

class OrderModelMapper {
    static func transform(_ model: OrderModel) -> Order {
        .init(salesLines: transform(model.items),
              receiptType: model.receiptType.rawValue,
              client: model.client,
              pointOfSaleId: Constants.pointOfSaleId,
              payment: model.payment)
    }
    
    static func transform(_ models: [OrderModel.Item]) -> [SalesLine] {
        models.map({ transform($0) })
    }
    
    static func transform(_ model: OrderModel.Item) -> SalesLine {
        .init(quantity: model.quantity,
              productId: model.productID?.uuidString ?? "")
    }
}
