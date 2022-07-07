//
//  ViewController.swift
//  BounceDemos
//
//  Created by Irem Karaoglu on 24.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var dotSize: CGFloat = 14.0
    var labels: [UILabel] = []
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
    
    override func viewDidLoad() {
        let label = UILabel()
        label.text = "Lorem"
        
        let label1 = UILabel()
        label1.text = "Ipsum"
        
        let label2 = UILabel()
        label2.text = "Dolor"
        
        let label3 = UILabel()
        label3.text = "Sit"
        
        let label4 = UILabel()
        label4.text = "Amet"
        
        
        var labelArray = [UILabel]()
        labelArray.append(label)
        labelArray.append(label1)
        labelArray.append(label2)
        labelArray.append(label3)
        labelArray.append(label4)
        self.labels = labelArray
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 252/255,  green: 242/255, blue: 210/255, alpha: 1)
        addPlayButton()
        createRow()
        addDot()
    }
    
    func addPlayButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        //        button.backgroundColor = UIColor(red: 161/255, green: 158/255, blue: 148/255, alpha: 1)
        button.layer.borderColor = UIColor(red: 161/255, green: 158/255, blue: 148/255, alpha: 1).cgColor
        button.layer.borderWidth = 2
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        button.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        startDotAnimation()
    }
    
    
    func addDot() {
        let ball = UIView()
        ball.layer.cornerRadius = dotSize/2
        ball.backgroundColor = UIColor(red: 242/255, green: 141/255, blue: 10/255, alpha: 1)
        ball.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ball)
        self.dot = ball
        
        NSLayoutConstraint.activate([
            ball.widthAnchor.constraint(equalToConstant: dotSize),
            ball.heightAnchor.constraint(equalToConstant: dotSize),
            ball.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: initialPoint.x),
            ball.topAnchor.constraint(equalTo: view.topAnchor, constant: initialPoint.y),
        ])
        
        
    }
    
    func createBezierPath() -> UIBezierPath? {
        var count = 0
        let path = UIBezierPath()
        var point = initialPoint
        point.x = initialPoint.x + labelWidths[0]/2 - 10
        var previousLabelWidth = 10.0
        var deltaX = 0.0
        
        for _ in labels {
            if labelWidths.isEmpty {
                break
            }
            
            deltaX = (previousLabelWidth  + (8*2) + labelWidths[count])/2
            
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
        
        let controlPoint1 = CGPoint(x:  point.x + 30,
                                    y: point.y - dotYvalue)
        let controlPoint2 = CGPoint(x:  point.x + 30,
                                    y: point.y - dotYvalue)
        let destination = CGPoint(x:  point.x + 60,
                                  y: point.y)
        point = destination
        points.append(destination)
        path.addCurve(to: destination, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        durations.append(0.3)
        
        return path
        
    }
    
    func startDotAnimation() {
        
        let path = createBezierPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path?.cgPath
        shapeLayer.fillColor = UIColor.systemPink.cgColor
        shapeLayer.strokeColor = UIColor.brown.cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(shapeLayer)
        
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
        initialPoint.x = (parentWidth - rowWidth)/2 - labelWidths[0]/2
        initialPoint.y = view.center.y - 20
        let topLeft: CGPoint = .init(x: (parentWidth - rowWidth)/2, y: initialPoint.y)
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
            view.addSubview(l)
        }
    }
}

