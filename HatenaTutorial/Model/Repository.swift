//
//  Repository.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

struct Repository: JSONDecodable {
    
    let id: Int
    let name: String
    let fullName: String
    let owner: User
    let isPrivate: Bool
    let htmlUrl: URL
    let description: String?
    let isFork: Bool
    let url: URL
    let createdAt: Date
    let updatedAt: Date
    let pushedAt: Date?
    let homepage: String?
    let size: Int
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    let masterBranch: String?
    let defaultBranch: String
    let score: Double
    
    init(_ json: JSONObject) throws {
        
        self.id = try json.get("id")
        self.name = try json.get("name")
        self.fullName = try json.get("full_name")
        self.owner = try json.get("owner")
        self.isPrivate = try json.get("private")
        self.htmlUrl = try json.get("html_url")
        self.description = try json.get("description")
        self.isFork = try json.get("fork")
        self.url = try json.get("url")
        self.createdAt = try json.get("created_at", converter: FormattedDateConverter(dateFormatter: DateHelper.dateFormatter))
        self.updatedAt = try json.get("updated_at", converter: FormattedDateConverter(dateFormatter: DateHelper.dateFormatter))
        self.pushedAt = try json.get("pushed_at", converter: FormattedDateConverter(dateFormatter: DateHelper.dateFormatter))
        self.homepage = try json.get("homepage")
        self.size = try json.get("size")
        self.stargazersCount = try json.get("stargazers_count")
        self.watchersCount = try json.get("watchers_count")
        self.language = try json.get("language")
        self.forksCount = try json.get("forks_count")
        self.openIssuesCount = try json.get("open_issues_count")
        self.masterBranch = try json.get("master_branch")
        self.defaultBranch = try json.get("default_branch")
        self.score = try json.get("score")
    }
}
