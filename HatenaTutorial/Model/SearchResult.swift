//
//  SearchResult.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

struct SearchResult<T: JSONDecodable>: JSONDecodable {
    
    let totalCount: Int
    let isIncompleteResults: Bool
    let items: [T]
    
    init(_ json: JSONObject) throws {
        
        self.totalCount = try json.get("total_count")
        self.isIncompleteResults = try json.get("incomplete_results")
        self.items = try json.get("items")
    }
}
