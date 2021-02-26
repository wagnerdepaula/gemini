//
//  NavigationViewController.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit

final class NavigationViewController: UINavigationController {
    
    static var shared: NavigationViewController = NavigationViewController()
    private let transactionsViewController = TransactionsViewController()
    private let loginViewController = LoginViewController()
    private let sendViewController = SendViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationViewController.shared = self
        setViewControllers([loginViewController], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem()
        updateNavigation()
    }
    
    public func updateNavigation() {
        
        let smallTitle = [NSAttributedString.Key.font: roundedFont(ofSize: 16, weight: .medium),
                          NSAttributedString.Key.foregroundColor: Color.primary,
                          NSAttributedString.Key.kern: 0] as [NSAttributedString.Key : Any]
        
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.tintColor = Color.cyan
        navigationBar.barTintColor = Color.background
        navigationBar.backgroundColor = Color.background
        navigationBar.titleTextAttributes = smallTitle
        
    }
    
    public func navigateToTransactions() {
        DispatchQueue.main.async {
            self.pushViewController(self.transactionsViewController, animated: true)
        }
    }
    
    public func navigateToTransaction() {
        DispatchQueue.main.async {
            self.pushViewController(self.transactionsViewController, animated: true)
        }
    }
    
    public func updateTransactions() {
        self.transactionsViewController.updateData()
    }
    
    public func navigateToSend() {
        DispatchQueue.main.async {
            self.present(self.sendViewController, animated: true, completion: nil)
        }
    }
    
    @objc public func navigateBackToLogin() {
        DispatchQueue.main.async {
            self.popViewController(animated: true)
        }
    }
    
   
}
