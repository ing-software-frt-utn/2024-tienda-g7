//
//  OrderRepository.swift
//  Orders
//
//  Created by Esteban Sánchez on 07/03/2024.
//

import Foundation

protocol OrderRepositoryProtocol {
    func confirmOrder(_ order: Order) async -> Receipt?
    func getTotal(_ salesLines: [SalesLine]) async -> Double
}

class OrderRepository: OrderRepositoryProtocol {
    
    func confirmOrder(_ order: Order) async -> Receipt? {
        let urlString = Constants.baseURL + Endpoints.orders
        
        do {
            guard let url = URL(string: urlString) else {
                throw HttpError.badURL
            }
            
            let receipt: Receipt = try await HttpClient.shared.sendData(to: url,
                                                                        object: order,
                                                                        httpMethod: .POST)
            return receipt
            
        } catch {
            print("❌ error: \(error)")
        }
        
        return nil
    }
    
    func getTotal(_ salesLines: [SalesLine]) async -> Double {
        let urlString = Constants.baseURL + Endpoints.orders + "/total"
        let body = GetTotal.Request(salesLines: salesLines)
        
        do {
            guard let url = URL(string: urlString) else { throw HttpError.badURL }
            
            let response: GetTotal.Response = try await HttpClient.shared.sendData(to: url,
                                                                                   object: body,
                                                                                   httpMethod: .POST)
            return response.total
            
        } catch {
            print("❌ error: \(error)")
        }
        
        return 0.0
    }
}

//class OrderLocalRepository: OrderRepositoryProtocol {
//    func confirmOrder(_ order: Order) async -> Receipt? {
//        return Receipt(type: .bill,
//                       items: [ .init(key: "Key", value: "Value") ])
//    }
//    
//    func getTotal(_ salesLines: [SalesLine]) async -> Double {
//        return 50.0
//    }
//}
