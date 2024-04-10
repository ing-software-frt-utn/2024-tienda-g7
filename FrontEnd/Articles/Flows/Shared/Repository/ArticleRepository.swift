//
//  ArticleListRepository.swift
//  Articles
//
//  Created by Esteban Sánchez on 06/03/2024.
//

import Foundation

protocol ArticleRepositoryProtocol {
    func fetchAll() async -> [Article]
    func delete(_ articleID: String) async
    func add(_ article: Article) async
    func getDetail(_ articleID: String) async -> Article?
}

class ArticleRepository: ArticleRepositoryProtocol {
    func fetchAll() async -> [Article] {
        let urlString = Constants.baseURL + Endpoints.articles
        
        do {
            guard let url = URL(string: urlString) else {
                throw HttpError.badURL
            }
            
            let response: [Article] = try await HttpClient.shared.fetch(url: url)
            return response
            
        } catch {
            print("❌ error: \(error)")
        }
        
        return []
    }
    
    func delete(_ articleID: String) async {
        let urlString = Constants.baseURL + Endpoints.articles + "/\(articleID)"
        
        do {
            guard let url = URL(string: urlString) else { throw HttpError.badURL }
            try await HttpClient.shared.delete(url: url)
            
        } catch {
            print("❌ error: \(error)")
        }
    }
    
    func add(_ article: Article) async {
        let urlString = Constants.baseURL + Endpoints.articles
        
        do {
            guard let url = URL(string: urlString) else {
                throw HttpError.badURL
            }
            
            try await HttpClient.shared.sendData(to: url,
                                                 object: article,
                                                 httpMethod: .POST)
        } catch {
            print("❌ error: \(error)")
        }
    }
    
    func getDetail(_ articleID: String) async -> Article? {
        let urlString = Constants.baseURL + Endpoints.articles + "/\(articleID)"
        
        do {
            guard let url = URL(string: urlString) else {
                throw HttpError.badURL
            }
            
            let response: Article = try await HttpClient.shared.fetch(url: url)
            
            return response
            
        } catch {
            print("❌ error: \(error)")
        }
        
        return nil
    }
}

//class ArticleLocalRepository: ArticleRepositoryProtocol {
//    var articles: [Article] = [
//        .init(id: UUID(),
//              name: "Articulo 1",
//              price: 20.00,
//              brand: .init(id: UUID(), name: "Lacoste"),
//              category: .init(id: UUID(), name: "Remera"),
//              products: [
//                .init(id: UUID(),
//                      color: .init(id: UUID(), name: "Rojo", hexCode: "#000000"),
//                      size: .init(id: UUID(uuidString: "911fd2f9-c55b-4128-9546-507584682625"), name: "M", type: .american),
//                      stock: 50),
//                .init(id: UUID(),
//                      color: .init(id: UUID(), name: "Rojo", hexCode: "#000000"),
//                      size: .init(id: UUID(uuidString: "7787b637-2407-4a95-a83c-0ce6eaa21cb9"), name: "Large", type: .european),
//                      stock: 70),
//                .init(id: UUID(),
//                      color: .init(id: UUID(), name: "Verde", hexCode: "#000000"),
//                      size: .init(id: UUID(), name: "L", type: .american),
//                      stock: 30),
//                .init(id: UUID(),
//                      color: .init(id: UUID(), name: "Verde", hexCode: "#000000"),
//                      size: .init(id: UUID(uuidString: "911fd2f9-c55b-4128-9546-507584682625"), name: "M", type: .american),
//                      stock: 20)
//              ])
//    ]
//    
//    func fetchAll() async -> [Article] {
//        return articles
//    }
//    
//    func delete(_ articleID: String) async {
//        guard let index = articles.firstIndex(where: { $0.id?.uuidString ?? "" == articleID }) else { return }
//        articles.remove(at: index)
//    }
//    
//    func add(_ article: Article) async {
//        articles.append(article)
//    }
//    
//    func getDetail(_ articleID: String) async -> Article? {
//        return articles.first(where: { $0.id?.uuidString ?? "" == articleID })
//    }
//}
