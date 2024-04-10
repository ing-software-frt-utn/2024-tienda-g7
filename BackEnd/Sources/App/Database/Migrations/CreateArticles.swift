import Fluent

struct CreateArticles: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("articles")
            .id()
            .field("name", .string, .required)
            .field("cost", .double, .required)
            .field("percentageIVA", .double, .required)
            .field("profitMargin", .double, .required)
            .field("brand_id", .uuid, .required, .references("brands", "id"))
            .field("category_id", .uuid, .required, .references("categories", "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("articles").delete()
    }
}
 
