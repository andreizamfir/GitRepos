//
//  FakeDataProvider.swift
//  GitReposTests
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import Foundation
@testable import GitRepos

class FakeDataProvider: NetworkManager {

    // MARK: - Properties

    var fakeError: GitRepoError
    var fakeRepositories: [Repository]

    // MARK: - Initialization

    init(fakeRepositories: [Repository], fakeError: GitRepoError) {
        self.fakeRepositories = fakeRepositories
        self.fakeError = fakeError
    }
    
    // MARK: - Overriden methods to return fake data
    
    override func login(urlRequest: URLRequest, completion: @escaping (Bool, GitRepoError?) -> Void) {
        completion(false, fakeError)
    }
    
}
