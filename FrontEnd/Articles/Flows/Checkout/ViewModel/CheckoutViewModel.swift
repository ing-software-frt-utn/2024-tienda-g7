//
//  CheckoutViewModel.swift
//  Articles
//
//  Created by Esteban Sánchez on 07/03/2024.
//

import SwiftUI
import Combine

class CheckoutViewModel: ObservableObject {
    
    @Published var receipt: Receipt? = nil
    @Published var total: Double = 0.0
    @Published var expirationMonth: Int = 1
    @Published var expirationYear: Int = 24
    
    let repository: OrderRepositoryProtocol
    
    // MARK: - Init
    
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public
    
    func confirmOrder(_ orderModel: OrderModel, completion: @escaping () -> Void) async {
        var order = OrderModelMapper.transform(orderModel)
        order.payment.cardInfo.cardExpirationYear = getExpirationYear()
        order.payment.cardInfo.cardExpirationMonth = getExpirationMonth()
        
        let response = await repository.confirmOrder(order)
        
        DispatchQueue.main.async {
            self.receipt = response
            completion()
        }
    }
    
    func getTotal(_ order: OrderModel) async {
        let order = OrderModelMapper.transform(order)
        let response = await repository.getTotal(order.salesLines)
        
        DispatchQueue.main.async {
            self.total = response
        }
    }
    
    // MARK: - Private
    
    private func getExpirationMonth() -> String {
        if expirationMonth < 10 {
            return "0\(expirationMonth)"
        } else {
            return "\(expirationMonth)"
        }
    }
    
    private func getExpirationYear() -> String {
        return "\(expirationYear)"
    }
}
