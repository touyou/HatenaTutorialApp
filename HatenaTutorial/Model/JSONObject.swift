//
//  JSONObject.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

// MARK: - Base Protocol

protocol JSONDecodable {
    
    init(_ json: JSONObject) throws
}

enum JSONDecodeError: Error {
    
    case missingRequireKey(String)
    case unexpectedType(key: String, expected: Any.Type, actual: Any.Type)
    case unexpectedValue(key: String, value: Any, message: String?)
    
    var debugDescription: String {
        
        switch self {
        case .missingRequireKey(let key):
            return "JSON Decode Error: Required key '\(key)' missing"
        case .unexpectedType(let key, let expected, let actual):
            return "JSON Decode Error: Unexpected type '\(actual)' was supplied for '\(key): \(expected)'"
        case .unexpectedValue(let key, let value, let message):
            return "JSON Decode Error: \(message ?? "Unexpected value") '\(value)' was supplied for '\(key)'"
        }
    }
}

// MARK: - Converter

protocol JSONValueConverter {
    
    associatedtype From
    associatedtype To
    
    func convert(key: String, value: From) throws -> To
}

struct DefaultConverter<T>: JSONValueConverter {
    
    typealias From = T
    typealias To = T
    
    func convert(key: String, value: T) throws -> T {
        
        return value
    }
}

struct ObjectConverter<T: JSONDecodable>: JSONValueConverter {
    
    typealias From = [String: Any]
    typealias To = T
    
    func convert(key: String, value: [String : Any]) throws -> T {
        
        return try T(JSONObject(json: value))
    }
}

struct ArrayConverter<T: JSONDecodable>: JSONValueConverter {
    
    typealias From = [[String: Any]]
    typealias To = [T]
    
    func convert(key: String, value: [[String : Any]]) throws -> [T] {
        
        return try value.map(JSONObject.init).map(T.init)
    }
}

// MARK: - Type
// MARK: Primitive
protocol JSONPrimitive {}

extension String: JSONPrimitive {}
extension Int: JSONPrimitive {}
extension Double: JSONPrimitive {}
extension Bool: JSONPrimitive {}
// MARK: Convertible
protocol JSONConvertible {
    
    associatedtype ConverterType: JSONValueConverter
    
    static var converter: ConverterType { get }
}

// MARK: - Object

struct JSONObject {
    
    let json: [String: Any]
    
    init(json: [String: Any]) {
        self.json = json
    }
    
    // MARK: get base
    
    func get<Converter: JSONValueConverter>(_ key: String, converter: Converter) throws -> Converter.To {
        
        guard let value = json[key] else {
            
            throw JSONDecodeError.missingRequireKey(key)
        }
        guard let typedValue = value as? Converter.From else {
            
            throw JSONDecodeError.unexpectedType(key: key, expected: Converter.From.self, actual: type(of: value))
        }
        
        return try converter.convert(key: key, value: typedValue)
    }
    
    func get<Converter: JSONValueConverter>(_ key: String, converter: Converter) throws -> Converter.To? {
        
        guard let value = json[key] else {
            
            return nil
        }
        if value is NSNull {
            
            return nil
        }
        guard let typedValue = value as? Converter.From else {
            
            throw JSONDecodeError.unexpectedType(key: key, expected: Converter.From.self, actual: type(of: value))
        }
        
        return try converter.convert(key: key, value: typedValue)
    }
    
    // MARK: Primitive
    
    func get<T: JSONPrimitive>(_ key: String) throws -> T {
        
        return try get(key, converter: DefaultConverter())
    }
    
    func get<T: JSONPrimitive>(_ key: String) throws -> T? {
        
        return try get(key, converter: DefaultConverter())
    }
    
    // MARK: Convertible
    
    func get<T: JSONConvertible>(_ key: String) throws -> T where T == T.ConverterType.To {
        
        return try get(key, converter: T.converter)
    }
    
    func get<T: JSONConvertible>(_ key: String) throws -> T? where T == T.ConverterType.To {
        
        return try get(key, converter: T.converter)
    }
    
    // MARK: Object
    
    func get<T: JSONDecodable>(_ key: String) throws -> T {
        
        return try get(key, converter: ObjectConverter())
    }
    
    func get<T: JSONDecodable>(_ key: String) throws -> T? {
        
        return try get(key, converter: ObjectConverter())
    }
    
    // MARK: Array
    
    func get<T: JSONDecodable>(_ key: String) throws -> [T] {
        
        return try get(key, converter: ArrayConverter())
    }
    
    func get<T: JSONDecodable>(_ key: String) throws -> [T]? {
        
        return try get(key, converter: ArrayConverter())
    }
}
