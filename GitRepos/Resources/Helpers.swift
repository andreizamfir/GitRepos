//
//  Helpers.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 07/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import Foundation

class Helpers {
    
    // MARK: - Encoding methods
    
    static func convertStringToData(string: String) -> Data? {
        return string.data(using: .utf8)
    }
    
    static func base64Encode(data: Data?) -> String? {
        return data?.base64EncodedString()
    }
    
    // MARK: - Create URL Request
    
    static func createUrlRequest(url: String, token: String?) -> URLRequest {
        // Create URL Request for Alamofire containing the credentials as an Authorization token
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = kGetMethod
        urlRequest.addValue("Basic \(token ?? "")", forHTTPHeaderField: kAuthorizationHeader)
        
        return urlRequest
    }
    
    // MARK: - Sorting methods
    
    static func sortAlphabetically(_ repositories: [Repository]) -> [Repository] {
        return repositories.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
    }
    
    static func sortByStars(_ repositories: [Repository]) -> [Repository] {
        return repositories.sorted { $0.stars > $1.stars }
    }
    
}
