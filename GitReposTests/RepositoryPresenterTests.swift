//
//  RepositoryTests.swift
//  GitReposTests
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import XCTest
@testable import GitRepos

class RepositoryPresenterTests: XCTestCase {
    
    // MARK: - Properties
    
    let repositoryPresenter = RepositoryPresenter()
    
    // MARK: - Initialization
    
    override func setUp() {
        repositoryPresenter.username = expectedUsername
        repositoryPresenter.repositories = [expectedRepository1, expectedRepository2, expectedRepository3]
    }

    // MARK: - Test methods
    
    func testGetNumberOfRepositories() {
        let count = repositoryPresenter.getNumberOfRepositories()
        XCTAssertLessThan(count, 10)
    }
    
    func testGetRepositoryForIndex() {
        let repository = repositoryPresenter.getRepositoryForIndex(index: 1)
        XCTAssertTrue(repository.name == expectedRepository2.name)
    }
    
    func testSorting() {
        // Sort by stars
        repositoryPresenter.sort()
        
        var firstRepository = repositoryPresenter.getRepositoryForIndex(index: 0)
        var lastRepository = repositoryPresenter.getRepositoryForIndex(index: 2)
        
        // Assert that the repositories are sorted by stars
        XCTAssertTrue(firstRepository.name == expectedRepository2.name)
        XCTAssertTrue(lastRepository.name == expectedRepository3.name)
        
        // Sort by alphabetically
        repositoryPresenter.sort()
        
        firstRepository = repositoryPresenter.getRepositoryForIndex(index: 0)
        lastRepository = repositoryPresenter.getRepositoryForIndex(index: 2)
        
        // Assert that the repositories are sorted alphabetically
        XCTAssertTrue(firstRepository.name == expectedRepository1.name)
        XCTAssertTrue(lastRepository.name == expectedRepository2.name)
    }

}
