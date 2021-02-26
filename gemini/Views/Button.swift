//
//  Button.swift
//  gemini
//
//  Created by Wagner De Paula on 2/22/21.
//

import UIKit


final class Button: UIButton {
    
    private var action: Any?
    private var title: String?
    
    private lazy var generator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        return generator
    }()
    
    convenience init(title: String, action: @escaping () -> ()) {
        self.init(frame: .zero)
        self.action = action
        self.title = title
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
    }
    
    private func setupView() {
        isOpaque = true
        backgroundColor = Color.cyan
        setTitle(title, for: .normal)
        setTitleColor(Color.background, for: .normal)
        titleLabel?.font = roundedFont(ofSize: 18, weight: .bold)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.unHighlight()
        generator.impactOccurred()
        guard let action = action as? () -> () else { return }
        action()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highlight()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.unHighlight()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.unHighlight()
    }
}

