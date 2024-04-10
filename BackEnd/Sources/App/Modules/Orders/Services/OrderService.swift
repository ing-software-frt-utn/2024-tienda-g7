//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 02/03/2024.
//

import Foundation
import Vapor
import Fluent

protocol OrderServiceProtocol {
    func create(orderDTO: CreateOrderDTO, req: Request) async throws -> Order
    func registerOrder(order: inout Order, req: Request) async throws
    func getTotal(of salesLinesDTO: [SalesLineDTO], req: Request) async throws -> Double
}

class OrderService: OrderServiceProtocol {
    
    // Repositories
    var pointOfSaleRepository: PointOfSaleRepositoryProtocol
    var orderRepository: OrderRepositoryProtocol
    var productRepository: ProductRepositoryProtocol
    
    init(pointOfSaleRepository: PointOfSaleRepositoryProtocol, orderRepository: OrderRepositoryProtocol, productRepository: ProductRepositoryProtocol) {
        self.pointOfSaleRepository = pointOfSaleRepository
        self.orderRepository = orderRepository
        self.productRepository = productRepository
    }
    
    func create(orderDTO: CreateOrderDTO, req: Request) async throws -> Order {
        guard let pointOfSaleId = UUID(uuidString: orderDTO.pointOfSaleId),
              let pointOfSale = try await pointOfSaleRepository.get(id: pointOfSaleId, req: req)
        else { throw CustomError.error(message: "Point of sale not found", status: .badRequest) }
    
        let order = pointOfSale.initSale()
        
        let salesLines = try await transform(orderDTO.salesLines, req: req)
        
        for salesLine in salesLines {
            order.addProduct(salesLine.product, quantity: salesLine.quantity)
        }
        
        return order
    }
    
    func registerOrder(order: inout Order, req: Request) async throws {
        // Actualizar stock
        for salesLine in order.salesLines {
            let product = salesLine.product
            let stockResult = product.stock - salesLine.quantity
            
            if stockResult > 0 {
                product.stock = stockResult
                try await productRepository.update(product, req: req)
            } else {
                try await productRepository.delete(product, req: req)
            }
        }
        
        try await orderRepository.save(&order, req: req)
    }
    
    func getTotal(of salesLinesDTO: [SalesLineDTO], req: Request) async throws -> Double {
        let salesLines = try await transform(salesLinesDTO, req: req)
        let order = Order(salesLines: salesLines)
        return order.getTotal()
    }
    
    private func transform(_ salesLinesDTO: [SalesLineDTO], req: Request) async throws -> [SalesLine] {
        var salesLines = [SalesLine]()
        
        for salesLine in salesLinesDTO {
            guard let uuid = UUID(uuidString: salesLine.productId),
                  let product = try await productRepository.get(id: uuid, req: req)
            else { throw CustomError.error(message: "Product not found", status: .notFound) }
            
            salesLines.append(SalesLine(quantity: salesLine.quantity, product: product))
        }
        
        return salesLines
    }
}
