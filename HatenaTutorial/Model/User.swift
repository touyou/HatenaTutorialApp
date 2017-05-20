//
//  User.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

struct User: JSONDecodable {
    
    let login: String
    let id: Int
    let avatarUrl: URL
    let gravatarId: String
    let url: URL
    let receivedEventsUrl: URL
    let type: String
    
    init(_ json: JSONObject) throws {
        
        self.login = try json.get("login")
        self.id = try json.get("id")
        self.avatarUrl = try json.get("avatar_url")
        self.gravatarId = try json.get("gravatar_id")
        self.url = URL(string: try json.get("url"))!
        self.receivedEventsUrl = try json.get("received_events_url")
        self.type = try json.get("type")
    }
}
