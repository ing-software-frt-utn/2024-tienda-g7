//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 09/03/2024.
//

@testable import App
import XCTVapor

final class OrderControllerTests: XCTestCase {
    var app: Application!
    var orderController: OrderController!
    // mocks
    var orderService: OrderServiceMock!
    var paymentService: PaymentServiceMock!
    var clientService: ClientServiceMock!
    
    override func setUp() {
        super.setUp()
        
        // Configurar la aplicación y los servicios mock
        app = Application(.testing)
        orderService = OrderServiceMock()
        paymentService = PaymentServiceMock()
        clientService = ClientServiceMock()
        orderController = OrderController(orderService: orderService,
                                          paymentService: paymentService,
                                          clientService: clientService)
        
        // Registrar el controlador en la aplicación
        try! app.register(collection: orderController)
    }
    
    override func tearDown() {
        // Liberar recursos
        app.shutdown()
        super.tearDown()
    }
    
    func test_create_success() async {
        // Given
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
        
        // When
        let receipt = try! await orderController.create(req: request)
        
        // Then
        XCTAssertEqual(receipt.type, ReceiptType.ticket)
        XCTAssertNil(receipt.billType)
        XCTAssertTrue(receipt.sections.count != 0)
    }
    
    func test_create_receiptInvalid() async {
        // Given
        let payment: CreateOrderDTO.Payment = .init(type: PaymentType.cash.rawValue,
                                                    cardInfo: nil)
        let salesLines: [SalesLineDTO] = [
            .init(quantity: 1, productId: "9d909f30-99e2-411e-8b17-ca588598b742")
        ]
        let content: CreateOrderDTO = .init(salesLines: salesLines,
                                            receiptType: "Not valid",
                                            client: nil,
                                            pointOfSaleId: "9d909f30-99e2-411e-8b17-ca588598b742",
                                            payment: payment)
        
        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // When
        do {
            _ = try await orderController.create(req: request)
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }
    
    func test_getTotal_success() async {
        // Given
        let content: GetOrderTotalDTO.Request = .init(salesLines: [
            .init(quantity: 1, productId: "9d909f30-99e2-411e-8b17-ca588598b742")
        ])
        let request = Request(application: app, method: .GET, url: "/orders/total", on: EmbeddedEventLoop())
        try! request.content.encode(content)
        
        // When
        let response = try! await orderController.getTotal(req: request)
        
        // Then
        XCTAssertEqual(20, response.total)
    }
}

// MARK: - Mocks

class OrderServiceMock: OrderServiceProtocol {
    func create(orderDTO: App.CreateOrderDTO, req: Vapor.Request) async throws -> App.Order {
        return .init(salesLines: [])
    }
    
    func registerOrder(order: inout App.Order, req: Vapor.Request) async throws {
        
    }
    
    func getTotal(of salesLinesDTO: [App.SalesLineDTO], req: Vapor.Request) async throws -> Double {
        return 20
    }
}

class PaymentServiceMock: PaymentServiceProtocol {
    func pay(order: inout App.Order, clientDTO: App.CreateOrderDTO.Client?, paymentDTO: App.CreateOrderDTO.Payment, req: Vapor.Request) async throws {
        
    }
}

class ClientServiceMock: ClientServiceProtocol {
    func createIfNeeded(_ clientDTO: App.CreateOrderDTO.Client, req: Vapor.Request) async throws -> App.Client {
        return .init(documentNumber: "12345678",
                     cuit: "20-12345678-5",
                     socialReason: "Cliente S.A.",
                     homeAddress: "Calle Principal 123",
                     tributaryCondition: .registeredResponsible)
    }
}
