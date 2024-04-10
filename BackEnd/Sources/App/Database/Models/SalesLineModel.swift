//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 01/03/2024.
//

import Fluent
import Vapor

final class SalesLineModel: Model {
    static let schema = "sales_lines"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Parent(key: "product_id")
    var product: ProductModel
    
    @OptionalParent(key: "order_id")
    var order: OrderModel?
    
    init() { }
    
    init(quantity: Int, productID: ProductModel.IDValue) {
        self.quantity = quantity
        self.$product.id = productID
    }
    
    init(id: UUID? = nil, quantity: Int, productID: ProductModel.IDValue, orderID: OrderModel.IDValue?) {
        self.id = id
        self.quantity = quantity
        self.$product.id = productID
        self.$order.id = orderID
    }
}

class SalesLinesModelMapper {
    static func transform(_ entities: [SalesLineModel]) -> [SalesLine] {
        entities.map({ transform($0) })
    }
    
    static func transform(_ entityDB: SalesLineModel) -> SalesLine {
        SalesLine(id: entityDB.id,
                  quantity: entityDB.quantity,
                  product: ProductModelMapper.transform(entityDB.product))
    }
    
    static func transform(_ entities: [SalesLine]) -> [SalesLineModel] {
        entities.map({ transform($0) })
    }
    
    static func transform(_ entity: SalesLine) -> SalesLineModel {
        SalesLineModel(id: entity.id,
                       quantity: entity.quantity,
                       productID: entity.product.id!,
                       orderID: entity.order?.id)
    }
}

