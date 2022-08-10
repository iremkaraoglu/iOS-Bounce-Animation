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
    var labelWidths: [CGFloat] = []
    var initialLabelWidth = 0.0
    var dotYvalue = 48.0
    var points = [CGPoint]()
    var durations = [CGFloat]()
    var initialPoint = CGPoint()
    var dot: UIView?
    
    override func viewDidLoad() {
        /*
         Bunu aslında project'in içinden Device Orientation ile de setleyebilirsin.
         Özel bir sebebi var mıydı? Bu haliyle bu arada döndürülebiliyor.
         Ama ilk başladığında hangi pozisyonda olmasını istiyorsan ona setleniyor. Döndürmeye çalıştığında dönebiliyor.
         Burada yaşatmak istediğin deneyim neydi?
        */
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        super.viewDidLoad()
        
        self.labels = ["Lorem", "Ipsum", "Dolor", "Sit", "Amet"].compactMap({
            let label = UILabel()
            label.text = $0
            return label
        })
        
        view.backgroundColor = UIColor(red: 252/255,  green: 242/255, blue: 210/255, alpha: 1)
        addPlayButton()
        createRow()
        addDot()
    }
    
    func addPlayButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor(red: 161/255, green: 158/255, blue: 148/255, alpha: 1).cgColor
        button.layer.borderWidth = 2
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
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
        // 91. satırda crash olur ve 102'de kontrol etmene gerek kalmaz. Bu yoksa zaten komple app gg.
        
        guard !labelWidths.isEmpty else { return nil }
        
        let path = UIBezierPath()
        var point = initialPoint
        point.x = initialPoint.x + labelWidths[0]/2 - 10
        var previousLabelWidth = 10.0
        var deltaX = 0.0
        
        
        for index in 0..<labels.count {
            deltaX = (previousLabelWidth  + (8*2) + labelWidths[index])/2
            
            if index == 0 {
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
            previousLabelWidth = labelWidths[index]
            durations.append(0.3)
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
        shapeLayer.fillColor = UIColor(red: 222/255, green: 120/255, blue: 180/255, alpha: 0.3).cgColor
        shapeLayer.strokeColor = UIColor(red: 222/255, green: 120/255, blue: 180/255, alpha: 0.9).cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(shapeLayer)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path?.cgPath
        
        animation.duration = durations.reduce(0, { partialResult, v in
            partialResult + v
        })
                
        // cd'nin anlamını anlamadım :(
        var cd = 0.0
        
        let times: [NSNumber] = durations.enumerated().compactMap({ index, duration in
            cd = cd + duration
            let xd = cd - duration*0.5
            return index + 1 == durations.count ? 1.0 : xd / animation.duration as NSNumber
        })

        animation.keyTimes = [0.0] + times
        self.dot?.layer.add(animation, forKey: "bezier")
        self.dot?.alpha = 1
        
        // May the force be with u not with code :d
        self.dot?.center = self.points.last!
    }
    
    // returns the width of a given UILabel
    func findWidthOfEachLabel(label: UILabel) -> CGFloat {
        let width = label.text?.size(withAttributes:[.font: label.font as Any]).width ?? 30
        return width
    }
    
    func createRow() {
        rowWidth = 0.0
        
        labelWidths = labels.compactMap({ label in
            label.constraints.forEach({ $0.isActive = false })
            let width = findWidthOfEachLabel(label: label)
            rowWidth += width
            return width
        })
        
        initialLabelWidth = labelWidths.first ?? .zero

        let parentWidth = UIScreen.main.bounds.width
        initialPoint.x = (parentWidth - rowWidth)/2 - labelWidths[0]/2
        initialPoint.y = view.center.y - 20
        let topLeft: CGPoint = .init(x: (parentWidth - rowWidth)/2, y: initialPoint.y)
        positionLabels(rowLabels: labels, rowStartPoint: topLeft)
    }
    
    func positionLabels(rowLabels: [UILabel], rowStartPoint: CGPoint) {
        var deltaX = rowStartPoint.x
        
        rowLabels.enumerated().forEach { index, label in
            label.frame = CGRect(x: deltaX, y: rowStartPoint.y , width: labelWidths[index], height: 20)
            deltaX = deltaX + 8 + labelWidths[index]
            view.addSubview(label)
        }
    }
}

