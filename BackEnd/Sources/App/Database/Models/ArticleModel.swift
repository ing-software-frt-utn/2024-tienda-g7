import Fluent
import Vapor

final class ArticleModel: Content, Model {
    static let schema = "articles"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "cost")
    var cost: Double
    
    @Field(key: "percentageIVA")
    var percentageIVA: Double
    
    @Field(key: "profitMargin")
    var profitMargin: Double
    
    @Parent(key: "brand_id")
    var brand: BrandModel
    
    @Parent(key: "category_id")
    var category: CategoryModel
    
    @Children(for: \.$article)
    var products: [ProductModel]

    init() { }
    
    init(id: UUID? = nil,
         name: String,
         cost: Double,
         percentageIVA: Double,
         profitMargin: Double,
         brandID: BrandModel.IDValue,
         categoryID: CategoryModel.IDValue
    ) {
        self.id = id
        self.name = name
        self.cost = cost
        self.percentageIVA = percentageIVA
        self.profitMargin = profitMargin
        self.$brand.id = brandID
        self.$category.id = categoryID
    }
    
    func getNetoGravado() -> Double {
        return cost + cost * profitMargin
    }
    
    func getIVA() -> Double {
        return getNetoGravado() * percentageIVA
    }
    
    func getPrice() -> Double {
        return getNetoGravado() + getIVA()
    }
}

class ArticleModelMapper {
    static func transform(_ entities: [ArticleModel]) -> [Article] {
        return entities.map({ transform($0) })
    }
    
    static func transform(_ entity: ArticleModel) -> Article {
        Article(id: entity.id,
                name: entity.name,
                cost: entity.cost,
                percentageIVA: entity.percentageIVA,
                profitMargin: entity.profitMargin,
                brand: BrandModelMapper.transform(entity.brand),
                category: CategoryModelMapper.transform(entity.category),
                products: ProductModelMapper.transform(entity.products))
    }
}
