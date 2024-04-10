//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 13/03/2024.
//

@testable import App
import XCTVapor

final class OrderServiceTests: XCTestCase {
    var app: Application!
    var orderService: OrderService!
    
    // mocks
    var pointOfSaleRepository: PointOfSaleRepositoryMock!
    var orderRepository: OrderRepositoryMock!
    var productRepository: ProductRepositoryMock!
    
    override func setUp() {
        super.setUp()
        
        // Configurar la aplicación y los servicios mock
        app = Application(.testing)
        self.pointOfSaleRepository = PointOfSaleRepositoryMock()
        self.orderRepository = OrderRepositoryMock()
        self.productRepository = ProductRepositoryMock()
        
        self.orderService = OrderService(pointOfSaleRepository: pointOfSaleRepository,
                                         orderRepository: orderRepository,
                                         productRepository: productRepository)
    }
    
    override func tearDown() {
        // Liberar recursos
        app.shutdown()
        super.tearDown()
    }
    
    func test_create_success() async {
        // given
        let payment: CreateOrderDTO.Payment = .init(type: PaymentType.cash.rawValue,
                                                    cardInfo: nil)
        let salesLines: [SalesLineDTO] = [
            .init(quantity: 1, productId: "9d909f30-99e2-411e-8b17-ca588598b742")
        ]
        let content: CreateOrderDTO = .init(salesLines: salesLines,
                                            receiptType: ReceiptType.ticket.rawValue,
                                            client: nil,
                                            pointOfSaleId: "9d909f30-99e2-411e-8b17-ca588598b742",
                                            payment: payment)
        
        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // when
        let order = try! await orderService.create(orderDTO: content, req: request)
        
        // then
        XCTAssertNotNil(order)
        XCTAssertNotNil(order.pointOfSale)
        XCTAssertEqual(order.salesLines.count, 1)
    }
    
    func test_create_pointOfSaleNotFound() async {
        // given
        self.orderService = OrderService(pointOfSaleRepository: PointOfSaleNilRepositoryMock(),
                                         orderRepository: orderRepository,
                                         productRepository: productRepository)
        let payment: CreateOrderDTO.Payment = .init(type: PaymentType.cash.rawValue,
                                                    cardInfo: nil)
        let salesLines: [SalesLineDTO] = [
            .init(quantity: 1, productId: "9d909f30-99e2-411e-8b17-ca588598b742")
        ]
        let content: CreateOrderDTO = .init(salesLines: salesLines,
                                            receiptType: ReceiptType.ticket.rawValue,
                                            client: nil,
                                            pointOfSaleId: "not valid id",
                                            payment: payment)
        
        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // when
        do {
            _ = try await orderService.create(orderDTO: content, req: request)
        } catch {
            // then
            XCTAssertNotNil(error)
        }
    }
    
    func test_registerOrder_success() async {
        // given
        let payment: CreateOrderDTO.Payment = .init(type: PaymentType.cash.rawValue,
                                                    cardInfo: nil)
        let salesLines: [SalesLineDTO] = [
            .init(quantity: 1, productId: "9d909f30-99e2-411e-8b17-ca588598b742")
        ]
        let content: CreateOrderDTO = .init(salesLines: salesLines,
                                            receiptType: ReceiptType.ticket.rawValue,
                                            client: nil,
                                            pointOfSaleId: "9d909f30-99e2-411e-8b17-ca588598b742",
                                            payment: payment)
        
        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // when
        let order = try! await orderService.create(orderDTO: content, req: request)
        
        // then
        XCTAssertNotNil(order)
    }
    
    func test_getTotal_success() async {
        // given
        let salesLines: [SalesLineDTO] = [
            .init(quantity: 1, productId: UUID().uuidString)
        ]
        let content: GetOrderTotalDTO.Request = .init(salesLines: salesLines)
        
        let request = Request(application: app, method: .POST, url: "/orders/total", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // when
        let total = try! await orderService.getTotal(of: salesLines, req: request)
        
        // then
        XCTAssertEqual(total, 44)
    }
    
    func test_getTotal_productNotFound() async {
        // given
        self.orderService = OrderService(pointOfSaleRepository: pointOfSaleRepository,
                                         orderRepository: orderRepository,
                                         productRepository: ProductNilRepositoryMock())
        
        let salesLines: [SalesLineDTO] = [
            .init(quantity: 1, productId: "9d909f30-99e2-411e-8b17-ca588598b742")
        ]
        let content: GetOrderTotalDTO.Request = .init(salesLines: salesLines)
        
        let request = Request(application: app, method: .POST, url: "/orders/total", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // when
        do {
            _ = try await orderService.getTotal(of: salesLines, req: request)
        } catch {
            // then
            XCTAssertNotNil(error)
        }
    }
}

// MARK: - Mocks

class PointOfSaleRepositoryMock: PointOfSaleRepositoryProtocol {
    func get(id: UUID, req: Vapor.Request) async throws -> App.PointOfSale? {
        return .init(id: UUID())
    }
}

class PointOfSaleNilRepositoryMock: PointOfSaleRepositoryProtocol {
    func get(id: UUID, req: Vapor.Request) async throws -> App.PointOfSale? {
        return nil
    }
}

class OrderRepositoryMock: OrderRepositoryProtocol {
    func save(_ entity: inout App.Order, req: Vapor.Request) async throws {
    
    }
    
    func update(_ entity: App.Order, req: Vapor.Request) async throws {
        
    }
    
    func get(id: UUID, req: Vapor.Request) async throws -> App.Order? {
        return .init(salesLines: [])
    }
    
}

class ProductRepositoryMock: ProductRepositoryProtocol {
    func get(id: UUID, req: Vapor.Request) async throws -> App.Product? {
        return .init(stock: 2,
                     color: .init(name: "rojo", hexCode: "#00000"),
                     size: .init(name: "large", type: .american),
                     price: 44.0,
                     description: "",
                     articleID: UUID())
    }
    
    func save(_ entity: App.Product, req: Vapor.Request) async throws { }
    func update(_ entity: App.Product, req: Vapor.Request) async throws { }
    func delete(_ entity: App.Product, req: Vapor.Request) async throws { }
}

class ProductNilRepositoryMock: ProductRepositoryProtocol {
    func get(id: UUID, req: Vapor.Request) async throws -> App.Product? { return nil }
    func save(_ entity: App.Product, req: Vapor.Request) async throws { }
    func update(_ entity: App.Product, req: Vapor.Request) async throws { }
    func delete(_ entity: App.Product, req: Vapor.Request) async throws { }
}
