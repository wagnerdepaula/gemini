//
//  Footer.swift
//  gemini
//
//  Created by Wagner De Paula on 2/24/21.
//

import UIKit


final class Footer: UIView {
    
    private lazy var sendButton: Button = {
        let sendButton = Button(title: "Send", action: self.send)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        return sendButton
    }()
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        isOpaque = true
        backgroundColor = Color.background
        addSubview(sendButton)
    }
    
    @objc private func send() {
        NavigationViewController.shared.navigateToSend()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            sendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
}
