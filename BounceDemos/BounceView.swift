//
//  BounceView.swift
//  BounceDemos
//
//  Created by Irem Karaoglu on 26.06.2022.
//

import Foundation
import UIKit

class BounceView : UIView {
    
    var dotSize: CGFloat
    var labels: [UILabel]
    var rowWidth = 0.0
    var row: [UILabel] = []
    var labelWidths: [CGFloat] = []
    var initialLabelWidth = 0.0
    var startingPoint = CGPoint()
    var dotYvalue = 48.0
    var points = [CGPoint]()
    var durations = [CGFloat]()
    var initialPoint = CGPoint()
    var dot: UIView?
    
    init(frame: CGRect, dotSize: CGFloat, labels: [UILabel]) {
        self.dotSize = dotSize
        self.labels = labels
        durations.append(0.3)
        durations.append(0.3)
        durations.append(0.3)
        durations.append(0.3)
        super.init(frame: frame)
        addPlayButton()
        
        createRow()
        addDot()
        //        startDotAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addPlayButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.backgroundColor = .gray
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        button.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        startDotAnimation()
    }
    
    
    func addDot() {
        let ball = UIView()
        ball.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 9 : 6
        ball.backgroundColor = .white
        ball.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ball)
        self.dot = ball
        
        NSLayoutConstraint.activate([
            ball.widthAnchor.constraint(equalToConstant: dotSize),
            ball.heightAnchor.constraint(equalToConstant: dotSize),
            ball.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: initialPoint.x),
            ball.topAnchor.constraint(equalTo: self.topAnchor, constant: initialPoint.y),
        ])
        
        
    }
    
    func createBezierPath() -> UIBezierPath? {
        var count = 0
        let path = UIBezierPath()
        var point = CGPoint(x: startingPoint.x - 8  , y: 70)
        var previousLabelWidth = 10.0
        var deltaX = 0.0
        
        for i in labels {
            if labelWidths.isEmpty {
                break
            }
            
            deltaX = (previousLabelWidth  + (8 * 2) + labelWidths[count])/2
            
            if count == 0 {
                path.move(to: point)
            }
            
            let controlPoint1 = CGPoint(x: point.x + deltaX/2,
                                        y: point.y - dotYvalue)
            let controlPoint2 = CGPoint(x: point.x + deltaX/2,
                                        y: point.y - dotYvalue)
            let destination = CGPoint(x: point.x + deltaX,
                                      y: point.y)
            point = destination
            points.append(destination)
            path.addCurve(to: destination, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            previousLabelWidth = labelWidths[count]
            durations.append(0.3)
            count += 1
        }
        
        let controlPoint1 = CGPoint(x:  point.x + 20,
                                    y: point.y - dotYvalue)
        let controlPoint2 = CGPoint(x:  point.x + 20,
                                    y: point.y - dotYvalue)
        let destination = CGPoint(x:  point.x + 40,
                                  y: point.y)
        point = destination
        points.append(destination)
        path.addCurve(to: destination, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        durations.append(0.3)
        
        return path
        
    }
    
    func startDotAnimation() {
        
        let path = createBezierPath()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path?.cgPath
        animation.duration = durations.reduce(0, { partialResult, v in
            return partialResult + v
        })
        var keyTimes: [NSNumber] = [0.0]
        var cd = 0.0
        var index = 0
        for d in durations {
            cd = cd + d
            let xd = cd - d*0.5
            var percent = xd / animation.duration as NSNumber
            if index + 1 == durations.count{
                percent = 1.0
            }
            keyTimes.append(percent)
            index += 1
        }
        
        animation.keyTimes = keyTimes
        self.dot?.layer.add(animation, forKey: "bezier")
        self.dot?.alpha = 1
        self.dot?.center = self.points.last!
        
        //        self.delay(seconds: 0.1) {
        //            self.dot.layer.zPosition = 999
        //            self.bringSubviewToFront(self.dot)
        //            self.dot.alpha = 1
        //        }
        //
        //        self.delay(seconds: animation.duration - 0.3) {
        //            self.dot.alpha = 0
        //        }
    }
    
    
    
    
    
    
    // returns the width of a given UILabel
    func findWidthOfEachLabel(label: UILabel) -> CGFloat {
        let width = label.text?.size(withAttributes:[.font: label.font]).width ?? 30
        return width
    }
    
    func createRow() {
        var count = 0
        rowWidth = 0.0
        row.removeAll()
        for l in labels {
            l.constraints.forEach({$0.isActive = false})
            let labelWidth = findWidthOfEachLabel(label: l)
            labelWidths.append(labelWidth)
            rowWidth += labelWidth
            row.append(l)
            if count == 0 {
                initialLabelWidth = labelWidth
            }
            count += 1
        }
        let parentWidth = UIScreen.main.bounds.width
        let topLeft: CGPoint = .init(x: (parentWidth - rowWidth)/2, y: self.center.y - 20)
        initialPoint.x = (parentWidth - rowWidth)/2 - labelWidths[0]/2
        initialPoint.y = self.center.y - 20
        positionLabels(rowLabels: row,  labelWidths: labelWidths, rowStartPoint: topLeft)
        
    }
    
    func positionLabels(rowLabels: [UILabel], labelWidths: [CGFloat], rowStartPoint: CGPoint) {
        var count = 0
        var deltaX = rowStartPoint.x
        self.startingPoint = CGPoint(x: deltaX, y: rowStartPoint.y)
        for l in rowLabels {
            l.constraints.forEach({$0.isActive = false})
            l.frame = CGRect(x: deltaX, y: rowStartPoint.y , width: labelWidths[count], height: 20)
            deltaX = deltaX + 8 + labelWidths[count]
            count += 1
            self.addSubview(l)
        }
    }
    
}
