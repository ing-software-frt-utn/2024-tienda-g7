//
//  File.swift
//  
//
//  Created by Esteban Sánchez on 15/03/2024.
//

import Foundation
import Vapor

class LogHelper {
    
    static func printJson(_ response: ClientResponse, req: Request) {
        // Convierte el ByteBuffer en un Data
        guard let responseData = response.body,
              let data = responseData.getData(at: 0, length: responseData.readableBytes)
        else {
            return
        }
        
        // Intenta decodificar el Data como JSON para imprimirlo legiblemente
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Response Body:")
            print(jsonString)
        } else {
            print("Unable to parse response body as JSON.")
        }
    }
    
    static func printJson<T: Codable>(_ body: T) {
        // Crear un JSONEncoder
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Convertir la estructura a JSON Data
        do {
            let jsonData = try encoder.encode(body)
            
            // Convertir JSON Data a String y imprimirlo
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Failed to convert JSON data to string.")
            }
        } catch {
            print("Error encoding struct to JSON: \(error)")
        }
    }
}
