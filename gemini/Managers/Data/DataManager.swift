//
//  DataManager.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit


public class DataManager: NSObject {
    
    static var shared: DataManager = DataManager()
    
    static var addressName: String = ""
    static var address: Address = Address()
    static var transactionItems: [TransactionItem] = []
    
    
    public lazy var session: URLSession = {
        return URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    }()
    
    // Get all transactions
    public func getAllTransactions(completion: @escaping () -> ()) {
        let urlString: String = "https://jobcoin.gemini.com/amply-matted/api/transactions"
        guard let url: URL = URL(string: urlString) else { return }
        let urlRequest: URLRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                var transactionItems: [TransactionItem] = try! JSONDecoder().decode([TransactionItem].self, from: data)
                transactionItems = transactionItems.sorted {$0.timestamp > $1.timestamp}
                DataManager.transactionItems = transactionItems
                completion()
            }
            
        }.resume()
    }
    
    // Get transactions by address
    public func getTransactions(for address: String, completion: @escaping () -> ()) {
        let urlString: String = "https://jobcoin.gemini.com/amply-matted/api/addresses/\(address)"
        guard let url: URL = URL(string: urlString) else { return }
        let urlRequest: URLRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                let addressItem: Address = try! JSONDecoder().decode(Address.self, from: data)
                DataManager.address = addressItem
                DataManager.addressName = address
                completion()
            }
            
        }.resume()
    }
    
    
    // Send jobcoins (make a transfer)
    public func sendCoins(toAddress: String, amount: String, completion: @escaping (Response) -> ()) {
        
        let urlString: String = "https://jobcoin.gemini.com/amply-matted/api/transactions"
        guard let url: URL = URL(string: urlString) else { return }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: String] = [
            "fromAddress": DataManager.addressName,
            "toAddress": toAddress,
            "amount": amount
        ]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                let response: Response = try! JSONDecoder().decode(Response.self, from: data)
                completion(response)
            }
        }.resume()
    }
   
    
}
