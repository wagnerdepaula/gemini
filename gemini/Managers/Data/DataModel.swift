//
//  DataModel.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import Foundation


// Address
public struct Address: Codable {
    var balance: String = "10"
    var transactions: [TransactionItem] = [TransactionItem()]
}

extension Address {
    init?(dict: [String: Any]) {
        
        var balance: String {
            return dict["balance"] as? String ?? self.balance
        }
        
        var transactions: [TransactionItem] {
            return dict["transactions"] as? [TransactionItem] ?? self.transactions
        }
        
        self.balance = balance
        self.transactions = transactions
    }
}


// Transaction item
public struct TransactionItem: Codable {
    
    var timestamp: String = "00000000"
    var fromAddress: String? = "Wagner"
    var toAddress: String = "Alice"
    var amount: String = "10"
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case fromAddress = "fromAddress"
        case toAddress = "toAddress"
        case amount = "amount"
    }
}

extension TransactionItem {
    init?(dict: [String: Any]) {
        
        var timestamp: String {
            return dict["timestamp"] as? String ?? self.timestamp
        }
        
        var fromAddress: String {
            return dict["fromAddress"] as? String ?? self.fromAddress ?? ""
        }
        
        var toAddress: String {
            return dict["toAddress"] as? String ?? self.toAddress
        }
        
        var amount: String {
            return dict["amount"] as? String ?? self.amount
        }
        
        self.timestamp = timestamp
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.amount = amount
    }
}


// Status
public struct Response: Codable {
    var status: String?
    var error: String?
}
