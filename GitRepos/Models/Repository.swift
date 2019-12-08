//
//  Repository.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import Foundation

struct Repository: Codable {
    
    struct Owner: Codable {
        var thumbnailUrl: String
        
        enum CodingKeys: String, CodingKey {
            case thumbnailUrl = "avatar_url"
        }
    }
    
    var name: String
    var stars: Int
    var owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case stars = "stargazers_count"
    }
    
}
