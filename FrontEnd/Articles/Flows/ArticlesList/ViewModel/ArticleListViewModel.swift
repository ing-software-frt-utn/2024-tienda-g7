//
//  ArticleListViewModel.swift
//  Articles
//
//  Created by Esteban Sánchez on 23/02/2024.
//

import SwiftUI
import Combine

class ArticleListViewModel: ObservableObject {
    
    let repository: ArticleRepositoryProtocol
    @Published var articles: [Article] = []
    
    // MARK: - Init
    init(repository: ArticleRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public
    func fetchArticles() async {
        let response = await repository.fetchAll()
        
        DispatchQueue.main.async {
            self.articles = response
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let articleID = articles[index].id.uuidString
            Task { await repository.delete(articleID) }
        }
        
        DispatchQueue.main.async {
            self.articles.remove(atOffsets: offsets)
        }
    }
}
