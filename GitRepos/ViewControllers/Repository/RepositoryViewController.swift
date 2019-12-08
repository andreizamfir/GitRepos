//
//  RepositoriesViewController.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblSorted: UILabel!
    
    @IBOutlet weak var tvRepositories: UITableView!
    
    // MARK: - Properties
    
    var presenter = RepositoryPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.attachView(repositoryView: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.dettachView()
    }
    
    // MARK: - Initialization
    
    func initializeTableView() {
        tvRepositories.delegate = self
        tvRepositories.dataSource = self
        
        tvRepositories.register(UINib(nibName: kRepositoryCellName, bundle: Bundle.main), forCellReuseIdentifier: kRepositoryCellIdentifier)
    }

    // MARK: - IBActions
    
    @IBAction func logOut(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sort(_ sender: UIButton) {
        presenter.sort()
    }
    
}

// MARK: - UITableViewDelegate extension

extension RepositoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRepositoryCellHeight
    }
    
}

// MARK: - UITableViewDataSource extension

extension RepositoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRepositories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRepositoryCellIdentifier, for: indexPath) as! RepositoryTableViewCell
        
        // Get repository information from the presenter
        let repository = presenter.getRepositoryForIndex(index: indexPath.row)
        let thumbnailUrl = presenter.getRepositoryThumbnailForIndex(index: indexPath.row)
        
        cell.lblName.text = repository.name
        cell.lblStar.text = String(repository.stars)
        cell.imgThumbnail.kf.setImage(with: thumbnailUrl)
        
        return cell
    }
    
}

// MARK: - RepositoryProtocol extension

extension RepositoryViewController: RepositoryProtocol {
    
    func setUsername(_ username: String?) {
        lblUsername.text = username
    }
    
    func setSortLabel(_ sortLabel: String) {
        lblSorted.text = sortLabel
    }
 
    func reloadData() {
        tvRepositories.reloadData()
    }
    
    func showAlert(error: GitRepoError?) {
        let alert = UIAlertController(title: kError, message: error?.description.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOK, style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    
}
