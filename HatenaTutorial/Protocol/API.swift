//
//  API.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

// MARK: - Base

enum HTTPMethod: String {
    
    case options
    case get
    case head
    case put
    case delete
    case trace
    case connect
}

protocol APIEndpoint {
    
    var url: URL { get }
    var method: HTTPMethod { get }
    var query: Parameters? { get }
    var headers: Parameters? { get }
    
    associatedtype ResponseType: JSONDecodable
}

struct Parameters: ExpressibleByDictionaryLiteral {
    
    typealias Key = String
    typealias Value = String?
    private(set) var parameters: [Key: Value] = [:]
    
    init(dictionaryLiteral elements: (Parameters.Key, Parameters.Value)...) {
        
        for case let (key, value?) in elements {
            
            parameters[key] = value
        }
    }
}

// MARK: - Default Property

extension APIEndpoint {
    
    var method: HTTPMethod {
        
        return .get
    }

    var query: Parameters? {
        
        return nil
    }
    
    var headers: Parameters? {
        
        return nil
    }
}

// MARK: - URLRequest

extension APIEndpoint {
    
    var urlRequest: URLRequest {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = query?.parameters.map(URLQueryItem.init)
        
        var req = URLRequest(url: (components?.url)!)
        req.httpMethod = method.rawValue
        for case let (key, value?) in headers?.parameters ?? [:] {
            
            req.addValue(value, forHTTPHeaderField: key)
        }
        
        return req
    }
}

// MARK: - Request

enum APIError: Error {
    
    case emptyBody
    case unexpectedResponseType
}

enum APIResult<Response> {
    
    case success(Response)
    case failure(Error)
}

extension APIEndpoint {
    
    func request(_ session: URLSession, callback: @escaping (APIResult<ResponseType>) -> Void) -> URLSessionDataTask {
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let e = error {
                
                callback(.failure(e))
            } else if let data = data {
                
                do {
                    
                    guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        
                        throw APIError.unexpectedResponseType
                    }
                    let response = try ResponseType(JSONObject(json: dict))
                    callback(.success(response))
                } catch {
                    
                    callback(.failure(error))
                }
            } else {
                
                callback(.failure(APIError.emptyBody))
            }
        }
        task.resume()
        
        return task
    }
}
