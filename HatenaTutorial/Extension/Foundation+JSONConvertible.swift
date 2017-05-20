//
//  Foundation+JSONConvertible.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

// MARK: - URL

struct URLConverter: JSONValueConverter {
    
    typealias From = String
    typealias To = URL
    
    func convert(key: String, value: String) throws -> URLConverter.To {
        guard let url = URL(string: value) else {
            
            throw JSONDecodeError.unexpectedValue(key: key, value: value, message: "Invalid URL")
        }
        
        return url
    }
}

extension URL: JSONConvertible {
    typealias ConverterType = URLConverter
    
    static var converter: ConverterType {
        
        return URLConverter()
    }
}

// MARK: - Date

struct DateConverter: JSONValueConverter {
    
    typealias From = TimeInterval
    typealias To = Date
    
    func convert(key: String, value: TimeInterval) throws -> DateConverter.To {
        
        return Date(timeIntervalSince1970: value)
    }
}

extension Date: JSONConvertible {
    
    typealias ConverterType = DateConverter
    
    static var converter: ConverterType {
        
        return DateConverter()
    }
}
