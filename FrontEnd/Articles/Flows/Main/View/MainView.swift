//
//  MainView.swift
//  Articles
//
//  Created by Esteban Sánchez on 28/02/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var order: OrderModel = OrderModel()
    
    var body: some View {
        TabView {
            ArticleListView()
                .environmentObject(order)
                .tabItem {
                    Label("Article`s List", systemImage: "list.dash")
                }
            
            OrderView()
                .environmentObject(order)
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
