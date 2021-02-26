//
//  LoginViewController.swift
//  gemini
//
//  Created by Wagner De Paula on 2/15/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let transactionsViewController = TransactionsViewController()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView(frame: .zero)
        logoImageView.isOpaque = true
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    
    private lazy var addressField: TextField = {
        let addressField = TextField()
        addressField.text = ""
        addressField.placeholder = "Username"
        addressField.translatesAutoresizingMaskIntoConstraints = false
        return addressField
    }()
    
    
    private lazy var loginButton: Button = {
        let loginButton = Button(title: "Log in", action: self.logIn)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    
    private lazy var alertEmpy: UIAlertController = {
        let alert = UIAlertController(title: "Alert", message: "Please type in an address", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }()
    
    
    private lazy var alertNotFound: UIAlertController = {
        let alert = UIAlertController(title: "Alert", message: "No address found", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.isOpaque = true
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStackView()
        setupTextField()
        setupLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    
    private func setupView() {
        view.isOpaque = true
        view.backgroundColor = Color.background
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    
    private func setupStackView() {
        logoImageView.image = UIImage(named: "logo")
        if stackView.subviews.isEmpty {
            stackView.addArrangedSubview(logoImageView)
            stackView.setCustomSpacing(60, after: logoImageView)
            stackView.addArrangedSubview(addressField)
            stackView.addArrangedSubview(loginButton)
        }
    }
    
    
    private func showAlertEmpy() {
        DispatchQueue.main.async {
            self.present(self.alertEmpy, animated: true)
        }
    }
    
    
    private func showAlertNotFound() {
        DispatchQueue.main.async {
            self.present(self.alertNotFound, animated: true)
        }
    }
    
    
    private func logIn() {
        guard let address: String = addressField.text else { return }
        if !address.isEmpty {
            getData()
        } else {
            showAlertEmpy()
        }
    }
    
    
    @objc private func getData() {
        guard let address: String = addressField.text else { return }
        DataManager.shared.getTransactions(for: address) {
            if DataManager.address.transactions.isEmpty {
                self.showAlertNotFound()
            } else {
                NavigationViewController.shared.navigateToTransactions()
            }
        }
    }
    
    
    private func setupTextField() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(done))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc private func done() {
        view.endEditing(true)
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // stackView
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -50),
            
            // logoImageView
            logoImageView.widthAnchor.constraint(equalToConstant: 180),
            logoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            // addressLabel
            addressField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            addressField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            addressField.heightAnchor.constraint(equalToConstant: 54),
            
            // addressLabel
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 54),
        ])
    }
    
    
}

