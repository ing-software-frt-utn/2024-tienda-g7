//
//  HttpClient.swift
//  Articles
//
//  Created by Esteban Sánchez on 23/02/2024.
//

import Foundation

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

enum HttpMethod: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

class HttpClient {
    static let shared = HttpClient()
    
    private init() { }
    
    func fetch<T: Codable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        LogHelper.log(data, url: url, httpMethod: .GET)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode(T.self, from: data) else {
            throw HttpError.errorDecodingData
        }
        
        return object
    }
    
    func sendData<T: Codable, N: Codable>(to url: URL, object: T, httpMethod: HttpMethod) async throws -> N {
        let data = try await sendData(to: url, object: object, httpMethod: httpMethod)
        
        guard let object = try? JSONDecoder().decode(N.self, from: data) else {
            throw HttpError.errorDecodingData
        }
        
        LogHelper.log(data, url: url, httpMethod: httpMethod)
        
        return object
    }
    
    @discardableResult
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: HttpMethod) async throws -> Data {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        request.httpBody = try? JSONEncoder().encode(object)
        
        LogHelper.log(object, url: url, httpMethod: httpMethod)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        LogHelper.log(data, url: url, httpMethod: httpMethod)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        return data
    }
    
    func delete(url: URL) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: request)
        LogHelper.log(data, url: url, httpMethod: .DELETE)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
