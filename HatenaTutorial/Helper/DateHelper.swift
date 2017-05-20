//
//  DateHelper.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

class DateHelper {
    static var dateFormatter: DateFormatter {
            
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }
}

struct FormattedDateConverter: JSONValueConverter {
    
    typealias From = String
    typealias To = Date
    
    fileprivate let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        
        self.dateFormatter = dateFormatter
    }
    
    func convert(key: String, value: String) throws -> DateConverter.To {
        guard let date = dateFormatter.date(from: value) else {
            
            throw JSONDecodeError.unexpectedValue(key: key, value: value, message: "Invalid date format for \(dateFormatter.dateFormat)")
        }
        
        return date
    }
}
