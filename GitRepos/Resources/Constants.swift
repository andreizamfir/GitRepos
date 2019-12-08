//
//  Constants.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 07/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import UIKit

// MARK: - Endpoints

let kBaseUrl = "https://api.github.com"
let kUsersEndpoint = "/users/"
let kReposEndpoint = "/repos?"
let kTypeParameter = "type=all"
let kGetMethod = "GET"
let kAuthorizationHeader = "Authorization"

// MARK: - UI elements

let kRepositoryStoryboard = "Repository"
let kRepositoryCellIdentifier = "RepositoryCellIdentifier"
let kRepositoryCellName = "RepositoryTableViewCell"
let kRepositoryCellHeight: CGFloat = 50
let kNumberOfRepositories = 10

// MARK: - Errors

// NOTE: These are ususally put in the Localizable.strings file to internalize based on country/language
let kError = "Error"
let kOK = "OK"
