//
//  TextField.swift
//  gemini
//
//  Created by Wagner De Paula on 2/25/21.
//

import UIKit


final class TextField: UITextField {
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * 0.5
    }
    
    private func setupView() {
        isOpaque = true
        textColor = Color.primary
        textAlignment = .center
        backgroundColor = Color.tertiary.withAlphaComponent(0.2)
        font = roundedFont(ofSize: 18, weight: .medium)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.unHighlight()
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
