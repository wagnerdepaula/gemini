//
//  TransactionsViewController.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit

final class TransactionsViewController: UIViewController {
    
    private var address: Address = Address()
    private var transactions: [TransactionItem] = []
    
    private lazy var generator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        return generator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isOpaque = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0
        tableView.delaysContentTouches = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = Color.background
        tableView.backgroundColor = Color.background
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        return tableView
    }()
    
    private lazy var footer: Footer = {
        let footer = Footer()
        footer.translatesAutoresizingMaskIntoConstraints = false
        return footer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigation()
        updateData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    private func setupView() {
        view.isOpaque = true
        view.backgroundColor = Color.background
        view.addSubview(tableView)
        view.addSubview(footer)
    }
    
    public func updateData() {
        self.tableView.alpha = 0
        DataManager.shared.getTransactions(for: DataManager.addressName) {
            self.transactions = DataManager.address.transactions.sorted {$0.timestamp > $1.timestamp}
            self.address = DataManager.address
            self.tableView.fadeIn()
            self.tableView.reloadData()
        }
    }
    
    private func updateNavigation() {
        navigationItem.title = "Transactions"
        NavigationViewController.shared.updateNavigation()
        
        
        let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        logOutButton.setTitleTextAttributes([
            NSAttributedString.Key.font : roundedFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor : UIColor.cyan,
        ], for: .normal)
        navigationItem.rightBarButtonItem = logOutButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.heightAnchor.constraint(equalToConstant: 140),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func logOut() {
        NavigationViewController.shared.navigateBackToLogin()
    }
}



extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Header()
        header.config(with: address)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 320
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else { return UITableViewCell() }
        if transactions.count > 0 {
            let transactionItem = transactions[indexPath.row]
            cell.config(with: transactionItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.transactions.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.highlight()
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.unHighlight()
    }
    
}
