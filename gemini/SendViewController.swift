//
//  SendViewController.swift
//  gemini
//
//  Created by Wagner De Paula on 2/25/21.
//


import UIKit


class SendViewController: UIViewController {
    
    private let transactionsViewController = TransactionsViewController()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var swipeIndicator: UIView = {
        let swipeIndicator = UIView(frame: .zero)
        swipeIndicator.layer.cornerRadius = 3
        swipeIndicator.translatesAutoresizingMaskIntoConstraints = false
        swipeIndicator.backgroundColor = Color.tertiary
        return swipeIndicator
    }()
    
    private lazy var amountLabel: UILabel = {
        let amountLabel = UILabel(frame: .zero)
        amountLabel.isOpaque = true
        amountLabel.font = roundedFont(ofSize: 18, weight: .bold)
        amountLabel.textColor = Color.tertiary
        amountLabel.numberOfLines = 0
        amountLabel.textAlignment = .center
        amountLabel.text = "Amount"
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()
    
    private lazy var toAddressLabel: UILabel = {
        let toAddressLabel = UILabel(frame: .zero)
        toAddressLabel.isOpaque = true
        toAddressLabel.font = roundedFont(ofSize: 18, weight: .bold)
        toAddressLabel.textColor = Color.tertiary
        toAddressLabel.numberOfLines = 0
        toAddressLabel.textAlignment = .center
        toAddressLabel.text = "To address"
        toAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        return toAddressLabel
    }()
    
    private lazy var amountField: UITextField = {
        let amountField = UITextField(frame: .zero)
        amountField.isOpaque = true
        amountField.textColor = Color.primary
        amountField.textAlignment = .center
        amountField.placeholder = "0"
        amountField.keyboardType = .decimalPad
        amountField.font = roundedFont(ofSize: 56, weight: .medium)
        amountField.translatesAutoresizingMaskIntoConstraints = false
        return amountField
    }()
    
    private lazy var addressField: UITextField = {
        let addressField = UITextField(frame: .zero)
        addressField.isOpaque = true
        addressField.textColor = Color.primary
        addressField.textAlignment = .center
        addressField.placeholder = "Name"
        addressField.font = roundedFont(ofSize: 32, weight: .medium)
        addressField.translatesAutoresizingMaskIntoConstraints = false
        return addressField
    }()
    
    private lazy var completeLabel: UILabel = {
        let completeLabel = UILabel(frame: .zero)
        completeLabel.isOpaque = true
        completeLabel.font = roundedFont(ofSize: 26, weight: .bold)
        completeLabel.textColor = Color.primary
        completeLabel.numberOfLines = 0
        completeLabel.textAlignment = .center
        completeLabel.text = "Transfer Complete! 🎉"
        completeLabel.translatesAutoresizingMaskIntoConstraints = false
        return completeLabel
    }()
    
    private lazy var sendButton: Button = {
        let sendButton = Button(title: "Send", action: self.sendCoins)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.isOpaque = true
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupStackView()
        setupFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    private func setupView() {
        view.isOpaque = true
        view.backgroundColor = Color.charcoal
        view.addSubview(swipeIndicator)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(sendButton)
    }
    
    private func setupStackView() {
        resetStackView()
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(amountField)
        stackView.setCustomSpacing(30, after: amountField)
        stackView.addArrangedSubview(toAddressLabel)
        stackView.addArrangedSubview(addressField)
        stackView.setCustomSpacing(60, after: addressField)
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alert.message = message
            self.present(self.alert, animated: true)
        }
    }
    
    private func sendCoins() {
        guard let amount: String = amountField.text else { return }
        guard let address: String = addressField.text else { return }
        let amountNum: CGFloat = CGFloat((amount as NSString).doubleValue)
        
        if amount.isEmpty || amountNum == 0 {
            showAlert(message: "Please enter an amount")
        } else if address.isEmpty{
            showAlert(message: "Please enter an address")
        } else if address == DataManager.addressName {
            showAlert(message: "You can't send jobcoins to yourself!")
        } else {
            DataManager.shared.sendCoins(toAddress: address, amount: amount) {response in
                if response.status == nil {
                    self.showAlert(message: response.error ?? "Something went wrong")
                } else {
                    self.complete()
                }
            }
        }
    }

    
    private func setupFields() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(done))
        view.addGestureRecognizer(tap)
        sendButton.isHidden = false
    }
    
    @objc private func done() {
        view.endEditing(true)
    }
    
    private func resetStackView() {
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func complete() {
        resetStackView()
        stackView.addArrangedSubview(completeLabel)
        sendButton.isHidden = true
        view.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true) {
                NavigationViewController.shared.updateTransactions()
            }
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // swipeIndicator
            swipeIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swipeIndicator.widthAnchor.constraint(equalToConstant: 40),
            swipeIndicator.heightAnchor.constraint(equalToConstant: 6),
            
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // stackView
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -50),
            
            // addressLabel
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 54),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
}

