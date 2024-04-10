//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 26/02/2024.
//

import Fluent
import Vapor

final class ProductModel: Model {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "stock")
    var stock: Int
    
    @Parent(key: "color_id")
    var color: ColorModel
    
    @Parent(key: "size_id")
    var size: SizeModel
    
    @Parent(key: "article_id")
    var article: ArticleModel
    
    init() { }
    
    init(id: UUID? = nil, stock: Int, colorID: ColorModel.IDValue, sizeID: SizeModel.IDValue, articleID: ArticleModel.IDValue) {
        self.id = id
        self.stock = stock
        self.$color.id = colorID
        self.$size.id = sizeID
        self.$article.id = articleID
    }
}

class ProductModelMapper {
    static func transform(_ entities: [ProductModel]) -> [Product] {
        entities.map({ transform($0) })
    }
    
    static func transform(_ entity: ProductModel) -> Product {
        return Product(id: entity.id,
                       stock: entity.stock,
                       color: ColorModelMapper.transform(entity.color),
                       size: SizeModelMapper.transform(entity.size),
                       price: entity.article.getPrice(),
                       description: entity.article.name,
                       articleID: entity.article.id!)
    }
    
    static func transform(_ entities: [Product]) -> [ProductModel] {
        entities.map({ transform($0) })
    }
    
    static func transform(_ entity: Product) -> ProductModel {
        ProductModel(id: entity.id,
                     stock: entity.stock,
                     colorID: entity.color.id!, 
                     sizeID: entity.size.id!,
                     articleID: entity.articleID)
    }
}
