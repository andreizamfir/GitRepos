//
//  LoginTests.swift
//  GitReposTests
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import XCTest
@testable import GitRepos

class LoginTests: XCTestCase {
    
    func testFailedLogin() {
        let urlRequest = Helpers.createUrlRequest(url: kBaseUrl, token: "")
        
        fakeDataProvider.login(urlRequest: urlRequest) { (success, error) in
            XCTAssertEqual(error?.description, expectedError.description)
        }
        
        // NOTE: I couldn't test the login method of the LoginPresenter, because it won't return a closure, so instead I just tested the NetworkManager login method
    }

}
