//
//  Header.swift
//  gemini
//
//  Created by Wagner De Paula on 2/24/21.
//

import UIKit


final class Header: UITableViewHeaderFooterView {
    
    public var address: Address = Address()
    private let barWidth: CGFloat = 20
    private let barSpace: CGFloat = 20
    private let topMargin: CGFloat = 20
    private let leftMargin: CGFloat = 20
    private let rightMargin: CGFloat = 20
    private let scrollViewHeight: CGFloat = 160
    private var didLayoutViews: Bool = false
    
    
    private lazy var balanceAmount: UILabel = {
        let balanceAmount = UILabel(frame: .zero)
        balanceAmount.isOpaque = true
        balanceAmount.font = roundedFont(ofSize: 52, weight: .medium)
        balanceAmount.textColor = Color.primary
        balanceAmount.numberOfLines = 0
        balanceAmount.textAlignment = .center
        balanceAmount.translatesAutoresizingMaskIntoConstraints = false
        return balanceAmount
    }()
    
    
    private lazy var balanceLabel: UILabel = {
        let balanceLabel = UILabel(frame: .zero)
        balanceLabel.isOpaque = true
        balanceLabel.font = roundedFont(ofSize: 14, weight: .medium)
        balanceLabel.textColor = Color.tertiary
        balanceLabel.numberOfLines = 0
        balanceLabel.textAlignment = .center
        balanceLabel.text = "Total Balance"
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        return balanceLabel
    }()
    
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.delaysContentTouches = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    private lazy var dataPoints: [CGPoint] = {
        guard let max = balances.compactMap({ return $0 }).max() else { return [] }
        var result: [CGPoint] = []
        for (index, balance) in balances.enumerated() {
            let x = CGFloat(index) * (barWidth + barSpace)
            let y = (scrollView.frame.height - topMargin) *  balance / CGFloat(max)
            result.append(CGPoint(x: x, y: y))
        }
        return result
    }()
    
    
    private lazy var balances: [CGFloat] = {
        
        var balances: [CGFloat] = []
        var totalBalance: CGFloat = CGFloat(NSString(string: address.transactions.first?.amount ?? "0").floatValue)
        balances.append(totalBalance)
        
        for index in 1..<address.transactions.count {
            let transactionItem: TransactionItem = address.transactions[index]
            let transactionValue: CGFloat = CGFloat(NSString(string: address.transactions[index].amount).floatValue)
            let hasSentToItself: Bool = !(transactionItem.toAddress == DataManager.addressName && transactionItem.fromAddress == DataManager.addressName)
            
            if hasSentToItself {
                if (transactionItem.toAddress == DataManager.addressName) {
                    totalBalance += transactionValue
                } else {
                    totalBalance -= transactionValue
                }
            }
            
            balances.append(totalBalance)
        }
        return balances
    }()
    
    
    private lazy var scrollViewWidth: CGFloat = {
        return CGFloat(address.transactions.count-1) * (barWidth + barSpace) + rightMargin
    }()
    
    
    public func config(with address: Address) {
        self.address = address
        setupView()
    }
    
    
    private func setupView() {
        addSubview(balanceAmount)
        addSubview(balanceLabel)
        addSubview(scrollView)
        setupLayout()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard didLayoutViews == false else { return }
        setupAmount()
        setupBars()
        setupLabels()
        setupScrollView()
        didLayoutViews = true
    }
    
    
    private func setupAmount() {
        balanceAmount.text = address.balance
    }
    
    
    private func setupScrollView() {
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: scrollViewHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: rightMargin)
        scrollView.setContentOffset(CGPoint(x: -leftMargin, y: 0), animated: false)
        if (scrollViewWidth + leftMargin + rightMargin) >= self.frame.width {
            animateScrollView()
        }
    }
    
    
    private func animateScrollView() {
        let xPos: CGFloat = scrollViewWidth - self.frame.width + rightMargin
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.8, 0, 0.25, 0.99))
            UIView.animate(withDuration: 2.5, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
                self.scrollView.contentOffset.x = xPos
            }, completion: nil)
            CATransaction.commit()
        }
    }
    
    
    private func setupBars() {
        for (index, dataPoint) in dataPoints.enumerated() {
            
            let delay: Double = Double(index) * 0.05
            let color: UIColor = Color.cyan
            let height: CGFloat =  dataPoint.y
            let x: CGFloat = dataPoint.x
            let y: CGFloat = scrollView.frame.height - height
            
            let barLayer: CALayer = CALayer()
            barLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            barLayer.frame = CGRect(x: x, y: y, width: barWidth, height: height)
            barLayer.backgroundColor = color.cgColor
            barLayer.cornerRadius = 2
            scrollView.layer.addSublayer(barLayer)
            
            DispatchQueue.main.async {
                let scale = CABasicAnimation(keyPath: "transform.scale.y")
                scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.2, 0.99)
                scale.duration = 0.5
                scale.fromValue = 0
                scale.toValue = 1
                scale.fillMode = .both
                scale.beginTime = CACurrentMediaTime() + delay
                barLayer.add(scale, forKey: "scale.y")
            }
        }
    }
    
    
    private func setupLabels() {
        for index in 0..<balances.count {
            
            let dataPoint: CGPoint = dataPoints[index]
            let delay: Double = Double(index) * 0.05
            let color: UIColor = Color.primary
            let height: CGFloat =  dataPoint.y
            let y: CGFloat = scrollView.frame.height - height
            
            let textLayerWidth: CGFloat = 60
            let textLayerX: CGFloat = (dataPoint.x - textLayerWidth * 0.5) + (barWidth * 0.5)
            let textLayerY: CGFloat = y - topMargin
            let textLayerText: String = String(format: "%.1f", balances[index])
            
            let textLayer: CATextLayer = CATextLayer()
            textLayer.frame = CGRect(x: textLayerX, y: textLayerY, width: textLayerWidth, height: 16)
            textLayer.foregroundColor = color.cgColor
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.alignmentMode = .center
            textLayer.font = roundedFont(ofSize: 10, weight: .semibold)
            textLayer.fontSize = 10
            textLayer.string = textLayerText
            scrollView.layer.addSublayer(textLayer)
            
            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.timingFunction = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.2, 0.99)
            opacity.duration = 0.5
            opacity.fromValue = 0
            opacity.toValue = 1
            opacity.fillMode = .both
            opacity.beginTime = CACurrentMediaTime() + delay + 0.3
            textLayer.add(opacity, forKey: "opacity")
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            // balanceAmount
            balanceAmount.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            balanceAmount.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            balanceAmount.heightAnchor.constraint(equalToConstant: 50),
            balanceAmount.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // balanceLabel
            balanceLabel.topAnchor.constraint(equalTo: balanceAmount.bottomAnchor, constant: 5),
            balanceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            balanceLabel.heightAnchor.constraint(equalToConstant: 14),
            balanceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // scrollView
            scrollView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    
}

