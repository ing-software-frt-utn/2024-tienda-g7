//
//  CheckoutView.swift
//  Articles
//
//  Created by Esteban Sánchez on 29/02/2024.
//

import SwiftUI

struct CheckoutView: View {
    
    @StateObject var viewModel: CheckoutViewModel
    @EnvironmentObject var order: OrderModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var receiptLoaded: Bool = false
    @Binding var path: [Int]
    
    var body: some View {
        Form {
            Section("Payment method") {
                Picker("How do you like to pay?", selection: $order.payment.type.animation()) {
                    ForEach(PaymentType.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                
                if order.payment.type == .creditCard || order.payment.type == .debitCard {
                    TextField("Card number", text: $order.payment.cardInfo.cardNumber)
                        .keyboardType(.numberPad)
                        .focused($isTextFieldFocused)
                    
                    TextField("Card holder name", text: $order.payment.cardInfo.cardHolderName)
                        .focused($isTextFieldFocused)
                    
                    TextField("Card holder document", text: $order.payment.cardInfo.cardHolderDocument)
                        .focused($isTextFieldFocused)
                    
                    Section("Expiration date") {
                        Stepper("Month \(viewModel.expirationMonth)",
                                value: $viewModel.expirationMonth,
                                in: 1...12)
                        
                        Stepper("Year \(viewModel.expirationYear)",
                                value: $viewModel.expirationYear,
                                in: 24...99)
                    }
                    
                    TextField("Security code", text: $order.payment.cardInfo.cardSecurityNumber)
                        .focused($isTextFieldFocused)
                }
                
                if order.payment.type == .cash  {
                    TextField("Cash amount", value: $order.cashAmount, format: .currency(code: Locale.current.currency?.identifier ?? "ARS"))
                        .keyboardType(.decimalPad)
                        .focused($isTextFieldFocused)
                    
                    Text(order.cashReturn, format: .currency(code: Locale.current.currency?.identifier ?? "ARS"))
                }
            }
            
            Section("Bill information") {
                Picker("Select receipt type", selection: $order.receiptType.animation()) {
                    ForEach(ReceiptType.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                
                if order.receiptType == .bill {
                    TextField("Document number", text: $order.client.documentNumber)
                        .focused($isTextFieldFocused)
                    
                    TextField("CUIT", text: $order.client.cuit)
                        .focused($isTextFieldFocused)
                    
                    TextField("Social reason", text: $order.client.socialReason)
                        .focused($isTextFieldFocused)
                    
                    TextField("Home", text: $order.client.homeAddress)
                        .focused($isTextFieldFocused)
                    
                    Picker("Tributary condition", selection: $order.client.tributaryCondition) {
                        ForEach(TributaryCondition.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
            }
            
            HStack {
                Text("Total: $\(viewModel.total)")
                Spacer()
                Button("Confirm order", action: confirmOrder)
                    .buttonStyle(.borderless)
            }
            
            if receiptLoaded, let receipt = viewModel.receipt {
                NavigationLink("See receipt", destination: ReceiptView(receipt: receipt, path: $path))
            }
        }.navigationTitle("Checkout")
            .onAppear {
                Task {
                    await viewModel.getTotal(order)
                }
            }
            .toolbar {
                if isTextFieldFocused {
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                }
            }
    }
    
    private func confirmOrder() {
        Task { 
            await viewModel.confirmOrder(order) {
                self.receiptLoaded = true
            }
        }
    }
}

#Preview {
    CheckoutView(viewModel: .init(repository: OrderRepository()), path: .constant([1]))
        .environmentObject(OrderModel())
}
