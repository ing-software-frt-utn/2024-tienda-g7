//
//  ArticleDetailViewModel.swift
//  Articles
//
//  Created by Esteban Sánchez on 28/02/2024.
//

import SwiftUI

final class ArticleDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var name = ""
    @Published var brand: String = ""
    @Published var category: String = ""
    
    @Published var selectedSizeType: String = ""
    @Published var sizeTypes: [String] = []
    
    @Published var selectedSize: UUID? = nil
    @Published var sizes: [Size] = []
    
    @Published var selectedColor: UUID? = nil
    @Published var colors: [Color] = []
    
    @Published var quantity: Int = 1
    @Published var stock: Int = 1
    
    @Published var currentArticle: Article? = nil
    @Published var currentProduct: Product? = nil
    
    var price: Double {
        (currentArticle?.price ?? 0.0) * Double(quantity)
    }
    var addButtonDisabled: Bool {
        currentArticle == nil || currentProduct == nil
    }
    
    private let articleRepository: ArticleRepositoryProtocol
    private let articleID: String
    private var possibleProducts: [Product] = []
    
    init(articleID: String, articleRepository: ArticleRepositoryProtocol) {
        self.articleID = articleID
        self.articleRepository = articleRepository
    }
    
    // MARK: - Public
    
    func fetchArticleDetail(onError: @escaping () -> Void) async {
        guard let article = await articleRepository.getDetail(articleID) else {
            onError()
            return
        }
        
        DispatchQueue.main.async {
            self.currentArticle = article
            self.name = article.name
            self.brand = article.brand.name
            self.category = article.category.name
            self.sizeTypes = Array(Set(article.products.map({ $0.size.type.rawValue })))
        }
    }
    
    func onSizeTypeSelected() {
        // buscar los sizes que se corresponden con el tipo
        guard let sizeType = SizeType(rawValue: selectedSizeType),
              let sizes = currentArticle?.products
            .filter({ $0.size.type == sizeType })
            .map({ $0.size })
        else { return }
        
        DispatchQueue.main.async {
            self.sizes = Array(Set(sizes))
            self.colors = []
            self.selectedColor = nil
            self.currentProduct = nil
        }
    }
    
    func onSizeSelected() {
        // buscar el producto que tenga ese size
        guard let sizeID = selectedSize,
              let possibleProducts = currentArticle?.products.filter({ $0.size.id == sizeID })
        else { return }
        
        // mostrar los colores correspondientes
        DispatchQueue.main.async {
            self.colors = possibleProducts.map({ $0.color })
            self.selectedColor = self.colors.first?.id
            self.currentProduct = nil
        }
    }
    
    func onColorSelected() {
        // buscar el producto que tenga ese size y ese color
        guard let sizeID = selectedSize,
              let colorID = selectedColor,
              let product = currentArticle?.products.first(where: { $0.size.id == sizeID && $0.color.id == colorID})
        else { return }
        
        DispatchQueue.main.async {
            self.stock = product.stock
            self.quantity = 1
            self.currentProduct = product
        }
    }
}
