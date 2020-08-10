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
    
    // the color of a given segment
    var color: UIColor
    
    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat
}


class ProgressView : UIView {
    
    private var currentAmount: CGFloat = 0
    private var totalAmount: CGFloat = 0
    
    /// An array of structs representing the segments of the pie chart
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
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        // get current context
        let ctx = UIGraphicsGetCurrentContext()
        
        // radius is the half the frame's width or height (whichever is smallest)
        let radius = (min(frame.size.width, frame.size.height) * 0.5)
        
        
        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        
        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = currentAmount + totalAmount
        
        
        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5
        
        
        
        // Transparent
        // set fill color to the segment color
        //ctx?.setFillColor(UIColor(white: 1, alpha: 0).cgColor)
        ctx?.setFillColor(UIColor(white: 1, alpha: 0).cgColor)
        
        // update the end angle of the segment
        let endAngle = startAngle + (2 * .pi * (currentAmount / CGFloat(valueCount)))
        
        // move to the center of the pie chart
        ctx?.move(to: viewCenter)
        
        // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
        ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        // fill segment
        ctx?.fillPath()
        
        // update starting angle of the next segment to the ending angle of this segment
        startAngle = endAngle
        
        
        
        // Color
        // set fill color to the segment color
        ctx?.setFillColor(#colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1))
        
        // update the end angle of the segment
        let endAngle2 = startAngle + (2 * .pi * (totalAmount / CGFloat(valueCount)))
        
        // move to the center of the pie chart
        ctx?.move(to: viewCenter)
        
        // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
        ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle2, clockwise: false)
        
        // fill segment
        ctx?.fillPath()
                
    }
    
}
