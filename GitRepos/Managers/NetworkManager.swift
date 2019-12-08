//
//  NetworkManager.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 07/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import Foundation
import Alamofire

class GitRepoError: Error {
    
    let description: ErrorDescription
    
    init(description: ErrorDescription) {
        self.description = description
    }
    
}

enum ErrorDescription: String {
    
    case badCredentials = "Bad credentials."
    case fillAllFields = "Please fill all fields."
    case dataError = "Error getting the data."
    case decodeError = "Error decoding the response."
    case requestError = "Request error."
    
}

public class NetworkManager {
    
    // MARK: - Properties
    
    private static var sharedNetworkManager: NetworkManager = {
        let alamofireManager = NetworkManager()
        
        return alamofireManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    // MARK: - Requests
    
    func login(urlRequest: URLRequest, completion: @escaping(_ success: Bool, _ error: GitRepoError?) -> Void) {
        Alamofire
            .request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure:
                    let error = GitRepoError(description: .badCredentials)

                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
    }
    
    func getRepositories(username: String, completion: @escaping(_ repositories: [Repository], _ success: Bool, _ error: GitRepoError?) -> Void) {
        let requestUrl = kBaseUrl + kUsersEndpoint + username + kReposEndpoint + kTypeParameter
        
        Alamofire
            .request(requestUrl)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    // Get the response as a String
                    guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8) else {
                        let error = GitRepoError(description: .dataError)

                        DispatchQueue.main.async {
                            completion([], false, error)
                        }

                        return
                    }

                    do {
                        // Decode the response into an array of repositories
                        let jsonData = utf8Text.data(using: .utf8)!
                        let decoder = JSONDecoder()
                        var repositories = try decoder.decode([Repository].self, from: jsonData)
                        
                        // Sort the repositories alphabetically
                        repositories = Helpers.sortAlphabetically(repositories)

                        DispatchQueue.main.async {
                            completion(repositories, true, nil)
                        }
                    } catch {
                        let error = GitRepoError(description: .decodeError)

                        DispatchQueue.main.async {
                            completion([], false, error)
                        }
                    }
                    
                case .failure:
                    let error = GitRepoError(description: .requestError)

                    DispatchQueue.main.async {
                        completion([], false, error)
                    }
                }
            }
    }
    
}
