//
//  LoginViewController.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 07/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import UIKit
import DSGradientProgressView

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: DSGradientProgressView!
    
    // MARK: - Constants
    
    let kUsernameTag = 1
    let kPasswordTag = 2
    
    // MARK: - Properties
    
    var presenter = LoginPresenter(networkManager: NetworkManager.shared())
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTextFields()
        initializeObservers()
        initializeGestures()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.attachView(loginView: self)
    }
    
    deinit {
        deinitializeObservers()
        presenter.dettachView()
    }
    
    // MARK: - Initialization
    
    func initializeTextFields() {
        tfUsername.delegate = self
        tfPassword.delegate = self
    }
    
    func initializeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    func deinitializeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initializeGestures() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
    }
    
    // MARK: - IBActions
    
    @IBAction func logIn(_ sender: UIButton) {
        presenter.login(username: tfUsername.text!, password: tfPassword.text!)
    }
    
    // MARK: - Keyboard helpers
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            // Set the ScrollView's contentInset to that of the height of the keyboard
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            
            // Create a rectangle that represents the whole window except the keyboard
            var aRect = self.view.frame
            aRect.size.height -= keyboardHeight

            let activeField: UITextField? = [tfUsername, tfPassword].first { $0.isFirstResponder }
            if let activeField = activeField {
                
                // If the created rectangle doesn't contain the active text field it means it's covered by the keyboard, so scroll underneath it
                if !aRect.contains(activeField.frame.origin) {
                    let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y - keyboardHeight)
                    scrollView.setContentOffset(scrollPoint, animated: true)
                }
            }
            
            // Note: the last part can occur on smaller screen phones
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate extension

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case kUsernameTag:
            tfPassword.becomeFirstResponder()
        case kPasswordTag:
            textField.resignFirstResponder()
            
            presenter.login(username: tfUsername.text!, password: tfPassword.text!)
        default:
            break
        }
        
        return true
    }
    
}

// MARK: - LoginViewProtocol extension

extension LoginViewController: LoginViewProtocol {
    
    func showActivityIndicator() {
        progressView.wait()
    }
    
    func hideShowActivityIndicator() {
        progressView.signal()
    }
    
    func showAlert(error: GitRepoError?) {
        let alert = UIAlertController(title: kError, message: error?.description.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOK, style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    
    func navigateTo(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
