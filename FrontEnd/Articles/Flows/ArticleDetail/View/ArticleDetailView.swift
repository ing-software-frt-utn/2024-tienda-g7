//
//  ArticleDetail.swift
//  Articles
//
//  Created by Esteban Sánchez on 28/02/2024.
//

import SwiftUI

struct ArticleDetailView: View {
    
    @StateObject var viewModel: ArticleDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var order: OrderModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section("Article") {
                    Text(viewModel.brand)
                    Text(viewModel.category)
                    Text(viewModel.name)
                }
                
                Section("Products in stock") {
                    if !viewModel.sizeTypes.isEmpty {
                        Picker("Select a size type", selection: $viewModel.selectedSizeType.animation()) {
                            ForEach(viewModel.sizeTypes, id: \.self) { item in
                                Text(item.capitalized).tag(item)
                            }
                        }
                    }
                    
                    if !viewModel.sizes.isEmpty {
                        Picker("Select a size", selection: $viewModel.selectedSize.animation()) {
                            ForEach(viewModel.sizes, id: \.self) { item in
                                Text(item.name).tag(item.id)
                            }
                        }
                    }
                    
                    if !viewModel.colors.isEmpty {
                        Picker("Select color", selection: $viewModel.selectedColor.animation()) {
                            ForEach(viewModel.colors, id: \.self) { item in
                                Text(item.name).tag(item.id)
                            }
                        }
                    }
                    
                    if viewModel.selectedColor != nil {
                        Stepper("Quantity: x\(viewModel.quantity)", value: $viewModel.quantity, in: 1...viewModel.stock)
                    }
                }.onChange(of: viewModel.selectedSizeType, viewModel.onSizeTypeSelected)
                    .onChange(of: viewModel.selectedSize, viewModel.onSizeSelected)
                    .onChange(of: viewModel.selectedColor, viewModel.onColorSelected)
            }
            
            HStack {
                Text(viewModel.price, format: .currency(code: Locale.current.currency?.identifier ?? "ARS"))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    guard let currentArticle = viewModel.currentArticle,
                          let currentProduct = viewModel.currentProduct
                    else { return }
                    
                    order.add(currentProduct,
                              from: currentArticle,
                              quantity: viewModel.quantity)
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Add to cart", systemImage: "cart.fill")
                }.buttonStyle(.borderedProminent)
                    .disabled(viewModel.addButtonDisabled)
            }.padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
        }.navigationTitle("Details")
            .onAppear {
                Task {
                    await viewModel.fetchArticleDetail {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
}
    
#Preview {
    ArticleDetailView(viewModel: .init(articleID: "1", articleRepository: ArticleRepository()))
        .environmentObject(OrderModel())
}
