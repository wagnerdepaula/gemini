//
//  UIView.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//


import UIKit

extension UIView {
   
    public func highlight() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction], animations: {
            self.alpha = 0.6
        })
    }
    
    public func unHighlight() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.allowUserInteraction], animations: {
            self.alpha = 1
        })
    }
    
    private func generateConfetti() -> [CAEmitterCell] {
        
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        let colors: [UIColor] = [Color.pink, Color.purple, Color.blue, Color.cyan, Color.teal, Color.lime, Color.orange]
        
        var image: UIImage {
            let color = colors[Int.random(in: 0...colors.count-1)]
            let imageRect: CGRect = CGRect(x: 0, y: 0, width: 10, height: 16)
            UIGraphicsBeginImageContext(imageRect.size)
            guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
            context.setFillColor(color.cgColor)
            context.fill(imageRect)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
            UIGraphicsEndImageContext()
            return image
        }
        
        for _ in 0..<20 {
            let cell = CAEmitterCell()
            cell.beginTime = 0
            cell.birthRate = 10
            cell.contents = image.cgImage
            cell.emissionRange = CGFloat(Double.pi)
            cell.spin = 4
            cell.lifetime = 4
            cell.spinRange = 6
            cell.scaleRange = 1
            cell.velocityRange = 800
            cell.yAcceleration = CGFloat.random(in: 300...1000)
            cells.append(cell)
        }
        
        return cells
    }
    
    public func startConfetti() {
        let generator = UINotificationFeedbackGenerator()
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: self.frame.size.width * 0.5, y: -400)
        emitter.emitterShape = .circle
        emitter.emitterSize = CGSize(width: self.frame.size.width, height: 2)
        emitter.emitterCells = generateConfetti()
        self.layer.addSublayer(emitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            emitter.birthRate = 0
        }
        
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
}
