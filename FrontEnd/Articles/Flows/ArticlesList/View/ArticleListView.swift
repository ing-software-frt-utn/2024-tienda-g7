//
//  ContentView.swift
//  Articles
//
//  Created by Esteban Sánchez on 23/02/2024.
//

import SwiftUI

struct ArticleListView: View {
    
    @StateObject var viewModel = ArticleListViewModel(repository: ArticleRepository())
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.articles) { article in
                    NavigationLink {
                        ArticleDetailView(viewModel: .init(articleID: article.id.uuidString, articleRepository: ArticleRepository()))
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.id.uuidString)
                                .font(.caption2)
                            
                            Text(article.price, format: .currency(code: Locale.current.currency?.identifier ?? "ARS"))
                                .font(.headline)
                            
                            Text(article.brand.name)
                                .font(.headline)
                            
                            Text(article.name)
                                .font(.body)
                        }
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .refreshable {
                Task { await viewModel.fetchArticles() }
            }
            .navigationTitle(Text("⚜️ Articles"))
        }.onAppear {
            Task { await viewModel.fetchArticles() }
        }
    }
}

#Preview {
    ArticleListView()
}
