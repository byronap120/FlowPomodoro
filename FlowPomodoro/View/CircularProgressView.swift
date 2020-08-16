//
//  ProgressView.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 7/25/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation
import UIKit



struct Segment {
    var color: UIColor
    var value: CGFloat
}


class CircularProgressView : UIView {
    private var currentAmount: CGFloat = 0
    private var totalAmount: CGFloat = 0
    
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }
    
    func updateValues( currentAmount: CGFloat, totalAmount: CGFloat){
        self.currentAmount = currentAmount
        self.totalAmount = totalAmount
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let radius = (min(frame.size.width, frame.size.height) * 0.5)
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let valueCount = currentAmount + totalAmount
        var startAngle = -CGFloat.pi * 0.5
        
        // First Section
        ctx?.setFillColor(UIColor(white: 1, alpha: 0).cgColor)
        let endAngle = startAngle + (2 * .pi * (currentAmount / CGFloat(valueCount)))
        ctx?.move(to: viewCenter)
        ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx?.fillPath()
        
        // Second Section
        startAngle = endAngle
        ctx?.setFillColor(#colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1))
        let endAngle2 = startAngle + (2 * .pi * (totalAmount / CGFloat(valueCount)))
        ctx?.move(to: viewCenter)
        ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle2, clockwise: false)
        ctx?.fillPath()
    }
    
}
