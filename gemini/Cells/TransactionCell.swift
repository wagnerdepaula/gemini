//
//  TransactionCell.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit


final class TransactionCell: UITableViewCell {
    
    private var transactionItem: TransactionItem = TransactionItem()
    
    private lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = Color.charcoal
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(frame: .zero)
        iconView.isOpaque = true
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = Color.cyan
        return iconView
    }()
    
    private lazy var fromLabel: UILabel = {
        let fromLabel = UILabel(frame: .zero)
        fromLabel.isOpaque = true
        fromLabel.font = roundedFont(ofSize: 14, weight: .regular)
        fromLabel.textColor = Color.secondary
        fromLabel.numberOfLines = 0
        fromLabel.textAlignment = .left
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        return fromLabel
    }()
    
    private lazy var toLabel: UILabel = {
        let toLabel = UILabel(frame: .zero)
        toLabel.isOpaque = true
        toLabel.font = roundedFont(ofSize: 14, weight: .regular)
        toLabel.textColor = Color.secondary
        toLabel.numberOfLines = 0
        toLabel.textAlignment = .left
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        return toLabel
    }()
    
    private lazy var fromAddressLabel: UILabel = {
        let fromAddressLabel = UILabel(frame: .zero)
        fromAddressLabel.isOpaque = true
        fromAddressLabel.font = roundedFont(ofSize: 14, weight: .bold)
        fromAddressLabel.textColor = Color.primary
        fromAddressLabel.numberOfLines = 0
        fromAddressLabel.textAlignment = .left
        fromAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        return fromAddressLabel
    }()
    
    private lazy var toAddressLabel: UILabel = {
        let toAddressLabel = UILabel(frame: .zero)
        toAddressLabel.isOpaque = true
        toAddressLabel.font = roundedFont(ofSize: 14, weight: .bold)
        toAddressLabel.textColor = Color.primary
        toAddressLabel.numberOfLines = 0
        toAddressLabel.textAlignment = .left
        toAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        return toAddressLabel
    }()
    
    private lazy var timestampLabel: UILabel = {
        let timestampLabel = UILabel(frame: .zero)
        timestampLabel.isOpaque = true
        timestampLabel.font = roundedFont(ofSize: 12, weight: .regular)
        timestampLabel.textColor = Color.tertiary
        timestampLabel.numberOfLines = 0
        timestampLabel.textAlignment = .left
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        return timestampLabel
    }()
    
    private lazy var amountLabel: UILabel = {
        let amountLabel = UILabel(frame: .zero)
        amountLabel.isOpaque = true
        amountLabel.font = roundedFont(ofSize: 24, weight: .medium)
        amountLabel.textColor = Color.primary
        amountLabel.numberOfLines = 0
        amountLabel.textAlignment = .left
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()
    
    public func config(with transactionItem: TransactionItem) {
        self.transactionItem = transactionItem
        setupView()
        setupLayout()
        updateViews()
    }
    
    private func setupView() {
        isOpaque = true
        separatorInset = .zero
        selectionStyle = .none
        tintColor = Color.primary
        backgroundColor = Color.background
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(fromLabel)
        containerView.addSubview(fromAddressLabel)
        containerView.addSubview(toLabel)
        containerView.addSubview(toAddressLabel)
        containerView.addSubview(timestampLabel)
        containerView.addSubview(amountLabel)
    }
    
    private func updateViews() {
        
        let transactionTypeString: String = (transactionItem.fromAddress == nil)  ? "Deposit" : "From "
        let transactionTypeIcon: String = (transactionItem.fromAddress == nil)  ? "arrow.down" : "arrow.left.arrow.right"
        let transactionTextSign: String = (transactionItem.toAddress == DataManager.addressName) ? "+" : "-"
        let transactionTextColor: UIColor = (transactionItem.toAddress == DataManager.addressName) ? Color.green : Color.red
        
        // icon
        iconView.image = UIImage(systemName: transactionTypeIcon)
        
        // label
        fromLabel.text = transactionTypeString
        fromAddressLabel.text = transactionItem.fromAddress
        toLabel.text = " to "
        toAddressLabel.text = transactionItem.toAddress
        timestampLabel.text = transactionItem.timestamp.date
        amountLabel.text = "\(transactionTextSign)\(transactionItem.amount)"
        amountLabel.textColor = transactionTextColor
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            // containerView
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            // iconView
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -1),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            // fromLabel
            fromLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15),
            fromLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            
            // fromAddressLabel
            fromAddressLabel.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor),
            fromAddressLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            
            // toLabel
            toLabel.leadingAnchor.constraint(equalTo: fromAddressLabel.trailingAnchor),
            toLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            
            // fromAddressLabel
            toAddressLabel.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor),
            toAddressLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            
            // timestampLabel
            timestampLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15),
            timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            // amountLabel
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            amountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
