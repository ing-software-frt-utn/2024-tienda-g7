//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 23/02/2024.
//

import Fluent
import Vapor

struct ArticleController: RouteCollection {
    let articlesRepository: ArticleRepositoryProtocol
    
    init(articlesRepository: ArticleRepositoryProtocol) {
        self.articlesRepository = articlesRepository
    }
    
    func boot(routes: RoutesBuilder) throws {
        let articles = routes.grouped("articles")
        articles.get(use: fetchAll)
        articles.post(use: create)
        articles.put(use: update)
        articles.group(":articleID") { article in
            article.delete(use: delete)
            article.get(use: getDetail)
        }
    }
    
    // GET /articles
    func fetchAll(req: Request) async throws -> [ArticleResponse] {
        let articles = try await articlesRepository.getAll(req: req)
        return ArticleResponseMapper.transform(articles)
    }
    
    // GET /articles/id
    func getDetail(req: Request) async throws -> ArticleResponse {
        guard let id: UUID = req.parameters.get("articleID") else {
            throw(Abort(.badRequest))
        }
        
        guard let article = try await articlesRepository.get(id: id, req: req) else {
            throw CustomError.error(message: "Article not found", status: .notFound)
        }
        
        return ArticleResponseMapper.transform(article)
    }
    
    // POST /articles
    func create(req: Request) async throws -> HTTPStatus {
        let article = try req.content.decode(ArticleModel.self)
        try await article.save(on: req.db)
        return .ok
    }
    
    // PUT /articles
    func update(req: Request) async throws -> HTTPStatus {
        let article = try req.content.decode(ArticleModel.self)
        
        guard let articleFromDb = try await ArticleModel.find(article.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        articleFromDb.name = article.name
        try await articleFromDb.update(on: req.db)
        return .ok
    }
    
    // DELETE /articles/id
    func delete(req: Request) async throws -> HTTPStatus {
        guard let article = try await ArticleModel.find(req.parameters.get("articleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await article.delete(on: req.db)
        return .ok
    }
}
