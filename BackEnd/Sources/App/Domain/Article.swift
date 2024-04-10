//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 04/03/2024.
//

import Foundation

final class Article {
    var id: UUID?
    var name: String
    var cost: Double
    var percentageIVA: Double
    var profitMargin: Double
    var brand: Brand
    var category: Category
    var products: [Product]
    
    init(id: UUID? = nil,
         name: String,
         cost: Double,
         percentageIVA: Double,
         profitMargin: Double,
         brand: Brand,
         category: Category,
         products: [Product]
    ) {
        self.id = id
        self.name = name
        self.cost = cost
        self.percentageIVA = percentageIVA
        self.profitMargin = profitMargin
        self.brand = brand
        self.category = category
        self.products = products
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
