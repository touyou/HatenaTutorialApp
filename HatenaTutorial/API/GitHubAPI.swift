//
//  GitHubEndpoint.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

// MARK: - Endpoint

protocol GitHubEndpoint: APIEndpoint {
    
    var path: String { get }
}

fileprivate let gitHubUrl = URL(string: "https://api.github.com/")!

extension GitHubEndpoint {
    
    var url: URL {
        
        return URL(string: path, relativeTo: gitHubUrl)!
    }
    
    var headers: Parameters? {
        
        return [
            
            "Accept": "application/vnd.github.v3+json",
        ]
    }
}

// MARK: - API

struct SearchRepositories: GitHubEndpoint {
    
    var path = "search/repositories"
    var query: Parameters? {
        
        return [
        
            "q": searchQuery,
            "page": String(page),
        ]
    }
    
    typealias ResponseType = SearchResult<Repository>
    
    let searchQuery: String
    let page: Int
    
    init(searchQuery: String, page: Int) {
        
        self.searchQuery = searchQuery
        self.page = page
    }
}
