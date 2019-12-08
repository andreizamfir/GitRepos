//
//  GitReposTests.swift
//  GitReposTests
//
//  Created by Andrei Zamfir on 07/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import XCTest
@testable import GitRepos

// MARK: - Mock properties

let expectedUsername = "andreizamfir"
let expectedThumbnailUrl = "https://avatars2.githubusercontent.com/u/19377347?v=4"
let expectedError = GitRepoError(description: .badCredentials)
let expectedRepository1 = Repository(name: "firstRepository", stars: 4, owner: Repository.Owner(thumbnailUrl: expectedThumbnailUrl))
let expectedRepository2 = Repository(name: "secondRepository", stars: 5, owner: Repository.Owner(thumbnailUrl: expectedThumbnailUrl))
let expectedRepository3 = Repository(name: "lastRepository", stars: 3, owner: Repository.Owner(thumbnailUrl: expectedThumbnailUrl))

let fakeDataProvider = FakeDataProvider(fakeRepositories: [expectedRepository1, expectedRepository2], fakeError: expectedError)

// MARK: - Git Repo tests

class GitReposTests: XCTestCase {

    func testSuccessfulInit() {
        XCTAssertNotNil(Repository(name: "gitRepository", stars: 120, owner: Repository.Owner(thumbnailUrl: expectedThumbnailUrl)), "Repository nil")
    }
    
}

// MARK: - Helpers tests

class HelpersTests: XCTestCase {
    
    func testCreateUrlRequest() {
        let urlRequest = Helpers.createUrlRequest(url: kBaseUrl, token: "")
        
        XCTAssertTrue(urlRequest.httpMethod == kGetMethod)
        XCTAssertTrue(urlRequest.allHTTPHeaderFields!["Authorization"] == "Basic ")
    }
    
    func testSortAlphabetically() {
        let sortedRepositories = Helpers.sortAlphabetically([expectedRepository1, expectedRepository2, expectedRepository3])
        
        XCTAssertEqual(sortedRepositories.first?.name, expectedRepository1.name)
        XCTAssertEqual(sortedRepositories.last?.name, expectedRepository2.name)
    }
    
    func testSortByStars() {
        let sortedRepositories = Helpers.sortByStars([expectedRepository1, expectedRepository2, expectedRepository3])
        
        XCTAssertTrue(sortedRepositories.first?.stars == expectedRepository2.stars)
        XCTAssertTrue(sortedRepositories.last?.stars == expectedRepository3.stars)
    }
    
}
