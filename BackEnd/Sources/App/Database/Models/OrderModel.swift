//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 29/02/2024.
//

import Fluent
import Vapor

final class OrderModel: Model {
    static let schema = "orders"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @OptionalParent(key: "receipt_id")
    var receipt: ReceiptModel?
    
    @OptionalParent(key: "client_id")
    var client: ClientModel?
    
    @OptionalParent(key: "point_of_sale_id")
    var pointOfSale: PointOfSaleModel?
    
    @OptionalParent(key: "payment_id")
    var payment: PaymentModel?
    
    @Children(for: \.$order)
    var salesLines: [SalesLineModel]
    
    init() { }
    
    init(id: UUID? = nil, 
         createdAt: Date? = nil,
         receiptID: ReceiptModel.IDValue?,
         clientID: ClientModel.IDValue?,
         pointOfSaleID: PointOfSaleModel.IDValue?,
         paymentID: PaymentModel.IDValue?
    ) {
        self.id = id
        self.createdAt = createdAt
        self.$receipt.id = receiptID
        self.$client.id = clientID
        self.$pointOfSale.id = pointOfSaleID
        self.$payment.id = paymentID
    }
}

class OrderModelMapper {
    static func transform(_ entityDB: OrderModel?) -> Order? {
        guard let entityDB = entityDB else { return nil }
        return transform(entityDB)
    }
    
    static func transform(_ entityDB: OrderModel) -> Order {
        Order(id: entityDB.id,
              createdAt: entityDB.createdAt,
              client: ClientModelMapper.transform(entityDB.client),
              pointOfSale: PointOfSaleModelMapper.transform(entityDB.pointOfSale),
              salesLines: SalesLinesModelMapper.transform(entityDB.salesLines))
    }
    
    static func transform(_ entity: Order) -> OrderModel {
        OrderModel(id: entity.id,
                   createdAt: entity.createdAt,
                   receiptID: entity.receipt?.id,
                   clientID: entity.client?.id,
                   pointOfSaleID: entity.pointOfSale?.id,
                   paymentID: entity.payment?.id)
    }
}
