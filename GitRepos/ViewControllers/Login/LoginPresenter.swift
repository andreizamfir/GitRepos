//
//  LoginViewPresenter.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 07/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import UIKit

protocol LoginViewProtocol {
    
    func showActivityIndicator()
    
    func hideShowActivityIndicator()
    
    func showAlert(error: GitRepoError?)
    
    func navigateTo(_ viewController: UIViewController)
    
}

class LoginPresenter {
    
    // MARK: - Properties
    
    fileprivate var loginView: LoginViewProtocol?
    var apiManager: NetworkManager
    
    // MARK: - Initialization
    
    init(networkManager: NetworkManager) {
        self.apiManager = networkManager
    }
    
    func attachView(loginView: LoginViewProtocol) {
        self.loginView = loginView
    }
    
    func dettachView() {
        self.loginView = nil
    }
    
    // MARK: - Event handling
    
    func login(username: String, password: String) {
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            loginView?.showAlert(error: GitRepoError(description: .fillAllFields))
            return
        }
        
        // Create the token based on the username and password the user inputs
        let credentialsString = "\(username):\(password)"
        let credentialsData = Helpers.convertStringToData(string: credentialsString)
        let token = Helpers.base64Encode(data: credentialsData)
        
        // Create a login URLRequest to use with Alamofire
        let urlRequest = Helpers.createUrlRequest(url: kBaseUrl, token: token)
        
        self.loginView?.showActivityIndicator()
        apiManager.login(urlRequest: urlRequest) { (success, error) in
            self.loginView?.hideShowActivityIndicator()
            
            if success {
                let repositorySB = UIStoryboard(name:kRepositoryStoryboard, bundle: Bundle.main)
                let repositoryVC = repositorySB.instantiateInitialViewController() as! RepositoryViewController
                repositoryVC.presenter.username = username
                
                self.loginView?.navigateTo(repositoryVC)
            } else {
                self.loginView?.showAlert(error: error)
            }
        }
    }
    
}
