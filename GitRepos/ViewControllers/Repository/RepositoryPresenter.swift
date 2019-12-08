//
//  RepositoriesPresenter.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import Foundation

enum Sort: String {

    case alphabetically = "alphabetically"
    case byStars = "by stars"

}

protocol RepositoryProtocol {
    
    func setUsername(_ username: String?)
    
    func setSortLabel(_ sortLabel: String)
        
    func reloadData()
    
    func showAlert(error: GitRepoError?)
}

class RepositoryPresenter {
    
    // MARK: - Properties
    
    fileprivate var repositoryView: RepositoryProtocol?
    private let apiManager = NetworkManager.shared()
    
    var username: String?
    var repositories: [Repository] = []
    
    var sorting: Sort = .alphabetically
    
    // MARK: - Initialization
    
    func attachView(repositoryView: RepositoryProtocol?) {
        self.repositoryView = repositoryView
        self.repositoryView?.setUsername(username)
        
        guard let username = username else {
            return
        }
        
        // Due to the fact that there's only one screen, we can afford to get the repositories in viewWillAppear
        apiManager.getRepositories(username: username) { (repositories, success, error) in
            if error != nil {
                self.repositoryView?.showAlert(error: error)
            } else {
                self.repositories = Helpers.sortAlphabetically(repositories)
                self.repositoryView?.reloadData()
            }
        }
    }
    
    func dettachView() {
        self.repositoryView = nil
    }
    
    // MARK: - Data handling
    
    func getNumberOfRepositories() -> Int {
        // Return whichever number is smaller, either 10 (requirement) or the number of repositories the user has
        return repositories.count < kNumberOfRepositories ? repositories.count : kNumberOfRepositories
    }
    
    func getRepositoryForIndex(index: Int) -> Repository {
        return repositories[index]
    }
    
    func getRepositoryThumbnailForIndex(index: Int) -> URL {
        return URL(string: repositories[index].owner.thumbnailUrl)!
    }
    
    // MARK: - Event handling
    
    func sort() {
        // Sort repositories by the type that's not used (either alphabetically or by stars)
        switch sorting {
        case .alphabetically:
            repositories = Helpers.sortByStars(repositories)
            sorting = .byStars
        case .byStars:
            repositories = Helpers.sortAlphabetically(repositories)
            sorting = .alphabetically
        }

        repositoryView?.setSortLabel(sorting.rawValue)
        repositoryView?.reloadData()
    }
    
}
