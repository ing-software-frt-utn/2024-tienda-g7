import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ArticleController(articlesRepository: ArticleFluentRepository()))
    try app.register(collection: BrandController())
    try app.register(collection: CategoryController())
    try app.register(collection: ColorController())
    
    let orderRepository = OrderFluentRepository()
    
    let clientService = ClientService(repository: ClientFluentRepository())
    
    let orderService = OrderService(pointOfSaleRepository: PointOfSaleFluentRepository(),
                                    orderRepository: orderRepository,
                                    productRepository: ProductFluentRepository())
    
    let paymentService = PaymentService(authorizePaymentService: AuthorizePaymentService(),
                                        clientService: clientService,
                                        orderRepository: orderRepository)
    
    let orderController = OrderController(orderService: orderService,
                                          paymentService: paymentService,
                                          clientService: clientService)
    
    try app.register(collection: orderController)
}
