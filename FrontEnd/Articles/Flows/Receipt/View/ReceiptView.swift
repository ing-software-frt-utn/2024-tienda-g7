//
//  ReceiptView.swift
//  Articles
//
//  Created by Esteban Sánchez on 29/02/2024.
//

import SwiftUI

struct ReceiptView: View {
    
    @State var receipt: Receipt
    @EnvironmentObject var order: OrderModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: [Int]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                ForEach(receipt.sections, id: \.title) { section in
                    Section(section.title) {
                        ForEach(section.items, id: \.key) { item in
                            HStack {
                                Text(item.key)
                                    .font(.footnote)
                                Spacer()
                                Text(item.value)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
            
            Button("Return to home", systemImage: "house.fill") {
                order.clean()
                path = []
            }.buttonStyle(.borderedProminent)
        }.navigationTitle("Receipt")
    }
}

#Preview {
    ReceiptView(receipt: Receipt(type: .bill, sections: []), path: .constant([1]))
        .environmentObject(OrderModel())
}
