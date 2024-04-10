//
//  OrderView.swift
//  Articles
//
//  Created by Esteban Sánchez on 28/02/2024.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: OrderModel
    @State private var path: [Int] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(order.items, id: \.self) { item in
                        HStack {
                            Text("\(item.description)")
                            
                            Spacer()
                            
                            Text("X\(item.quantity)")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(item.subtotal, format: .currency(code: Locale.current.currency?.identifier ?? "ARS"))
                                .fontWeight(.bold)
                        }
                    }.onDelete(perform: deleteItems)
                }
                
                HStack(alignment: .center) {
                    HStack {
                        Text("Subtotal: ")
                            .fontWeight(.bold)
                        
                        Text(order.subtotal, format: .currency(code: Locale.current.currency?.identifier ?? "ARS"))
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Button("Checkout") {
                        path.append(1)
                    }
                    .navigationDestination(for: Int.self) { int in
                        CheckoutView(viewModel: .init(repository: OrderRepository()), path: $path)
                    }
                    
                }.padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    .disabled(order.items.isEmpty)
            }.navigationTitle("Your order")
                .toolbar {
                    EditButton()
                }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
}

#Preview {
    OrderView()
        .environmentObject(OrderModel())
}
