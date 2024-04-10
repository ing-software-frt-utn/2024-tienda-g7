//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 29/02/2024.
//

import Fluent
import Vapor

struct OrderController: RouteCollection {
    let orderService: OrderServiceProtocol
    let paymentService: PaymentServiceProtocol
    let clientService: ClientServiceProtocol
    
    init(orderService: OrderServiceProtocol, paymentService: PaymentServiceProtocol, clientService: ClientServiceProtocol) {
        self.orderService = orderService
        self.paymentService = paymentService
        self.clientService = clientService
    }
    
    func boot(routes: RoutesBuilder) throws {
        routes.grouped("orders").post(use: create)
        routes.grouped("orders").grouped("total").post(use: getTotal)
    }
    
    // POST /orders
    func create(req: Request) async throws -> Receipt {
        // Limpiar datos
        let orderDTO = try req.content.decode(CreateOrderDTO.self)
        
        guard let receiptType = ReceiptType(rawValue: orderDTO.receiptType) else {
            throw CustomError.error(message: "Receipt type not valid", status: .badRequest)
        }
        
        // Crear venta
        var order = try await orderService.create(orderDTO: orderDTO, req: req)
        
        // Registrar pago
        try await paymentService.pay(order: &order,
                                     clientDTO: orderDTO.client,
                                     paymentDTO: orderDTO.payment,
                                     req: req)
        
        // Confirmar venta
        // TODO: LLamadas a AFIP
        
        // Registrar venta, actualizar stock
        try await orderService.registerOrder(order: &order, req: req)
        
        return order.getReceipt(for: receiptType)
    }
    
    // GET /orders/total
    func getTotal(req: Request) async throws -> GetOrderTotalDTO.Response {
        let requestDTO = try req.content.decode(GetOrderTotalDTO.Request.self)
        let total = try await orderService.getTotal(of: requestDTO.salesLines, req: req)
        return GetOrderTotalDTO.Response(total: total)
    }
}
