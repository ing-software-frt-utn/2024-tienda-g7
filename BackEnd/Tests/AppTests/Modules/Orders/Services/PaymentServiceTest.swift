@testable import App
import XCTVapor

final class PaymentServiceTests: XCTestCase {
    var app: Application!
    var paymentService: PaymentService!
    
    // mocks
    var authorizePaymentService: AuthorizePaymentServiceMock!
    var orderRepository: OrderRepositoryMock!
    var clientService: ClientServiceMock!
    
    override func setUp() {
        super.setUp()
        
        // Configurar la aplicación y los servicios mock
        app = Application(.testing)
        self.authorizePaymentService = AuthorizePaymentServiceMock()
        self.orderRepository = OrderRepositoryMock()
        self.clientService = ClientServiceMock()
        
        self.paymentService = PaymentService(authorizePaymentService: authorizePaymentService,
                                             clientService: clientService,
                                             orderRepository: orderRepository)
    }
    
    override func tearDown() {
        // Liberar recursos
        app.shutdown()
        super.tearDown()
    }
    
    func test_payCash_success() async {
        // given
        let paymentDTO: CreateOrderDTO.Payment = .init(type: PaymentType.cash.rawValue,
                                                       cardInfo: nil)

        let salesLines: [SalesLine] = [
            .init(quantity: 1,
                  product: .init(stock: 1,
                                 color: .init(name: "", hexCode: ""),
                                 size: .init(name: "", type: .american),
                                 price: 20,
                                 description: "",
                                 articleID: UUID()))
        ]
        
        var order: Order = .init(salesLines: salesLines)

        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        
        // when
        try! await paymentService.pay(order: &order,
                                      clientDTO: nil,
                                      paymentDTO: paymentDTO,
                                      req: request)
        
        // then
        XCTAssertNotNil(order.payment)
        XCTAssertEqual(order.payment?.type, .cash)
        XCTAssertNil(order.client)
    }

    func test_payDebitCard_success() async {
        // given
        let cardDTO: CreateOrderDTO.CardInfo = .init(cardNumber: "4507990000004905",
                                                     cardHolderName: "John Doe",
                                                     cardExpirationMonth: "08",
                                                     cardExpirationYear: "24",
                                                     cardSecurityNumber: "123",
                                                     cardHolderDocument: "25123456")
        let paymentDTO: CreateOrderDTO.Payment = .init(type: PaymentType.debitCard.rawValue,
                                                       cardInfo: cardDTO)
        let client: CreateOrderDTO.Client = .init(documentNumber: "12345678",
                                                  cuit: "20-12345678-5",
                                                  socialReason: "Cliente S.A.",
                                                  homeAddress: "Calle Principal 123",
                                                  tributaryCondition: TributaryCondition.registeredResponsible.rawValue)
        let salesLines: [SalesLine] = [
            .init(quantity: 1,
                  product: .init(stock: 1,
                                 color: .init(name: "", hexCode: ""),
                                 size: .init(name: "", type: .american),
                                 price: 20,
                                 description: "",
                                 articleID: UUID()))
        ]

        var order: Order = .init(salesLines: salesLines)

        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        
        // when
        try! await paymentService.pay(order: &order,
                                      clientDTO: client,
                                      paymentDTO: paymentDTO,
                                      req: request)
        
        // then
        XCTAssertNotNil(order.payment)
        XCTAssertEqual(order.payment?.type, .debitCard)
        XCTAssertNotNil(order.client)
    }
    
    func test_payCreditCard_success() async {
        // given
        let cardDTO: CreateOrderDTO.CardInfo = .init(cardNumber: "4507990000004905",
                                                     cardHolderName: "John Doe",
                                                     cardExpirationMonth: "08",
                                                     cardExpirationYear: "24",
                                                     cardSecurityNumber: "123",
                                                     cardHolderDocument: "25123456")
        let paymentDTO: CreateOrderDTO.Payment = .init(type: PaymentType.creditCard.rawValue,
                                                       cardInfo: cardDTO)
        let client: CreateOrderDTO.Client = .init(documentNumber: "12345678",
                                                  cuit: "20-12345678-5",
                                                  socialReason: "Cliente S.A.",
                                                  homeAddress: "Calle Principal 123",
                                                  tributaryCondition: TributaryCondition.registeredResponsible.rawValue)
        let salesLines: [SalesLine] = [
            .init(quantity: 1,
                  product: .init(stock: 1,
                                 color: .init(name: "", hexCode: ""),
                                 size: .init(name: "", type: .american),
                                 price: 20,
                                 description: "",
                                 articleID: UUID()))
        ]
        
        var order: Order = .init(salesLines: salesLines)
        
        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        
        // when
        try! await paymentService.pay(order: &order,
                                      clientDTO: client,
                                      paymentDTO: paymentDTO,
                                      req: request)
        
        // then
        XCTAssertNotNil(order.payment)
        XCTAssertEqual(order.payment?.type, .creditCard)
        XCTAssertNotNil(order.client)
    }
    
    func test_pay_notFound() async {
        // given
        let paymentDTO: CreateOrderDTO.Payment = .init(type: "Not valid payment type",
                                                       cardInfo: nil)
        let salesLines: [SalesLine] = [
            .init(quantity: 1,
                  product: .init(stock: 1,
                                 color: .init(name: "", hexCode: ""),
                                 size: .init(name: "", type: .american),
                                 price: 20,
                                 description: "",
                                 articleID: UUID()))
        ]
        
        var order: Order = .init(salesLines: salesLines)
        
        let request = Request(application: app, method: .POST, url: "/orders", on: EmbeddedEventLoop())
        
        // when
        do {
            try await paymentService.pay(order: &order,
                                         clientDTO: nil,
                                         paymentDTO: paymentDTO,
                                         req: request)
        } catch {
            // then
            XCTAssertNotNil(error)
        }
    }
}

// MARK: - Mocks

class AuthorizePaymentServiceMock: AuthorizePaymentServiceProtocol {
    func getToken(paymentDTO: App.CreateOrderDTO.Payment, req: Vapor.Request) async throws -> App.AuthorizePaymentDTO.TokenResponse {
        return .init(id: "", bin: "")
    }
    
    func authorize(with token: String, bin: String, amount: Double, req: Request) async throws -> AuthorizePaymentDTO.AuthorizeResponse {
        return .init(status: "approved", status_details: .init(ticket: "123543"))
    }
}
