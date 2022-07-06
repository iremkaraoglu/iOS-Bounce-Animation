//
//  ViewController.swift
//  BounceDemos
//
//  Created by Irem Karaoglu on 24.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        addBounceView()
    }
    

    
    func addBounceView() {
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
        let bounceView = BounceView(frame: CGRect(x:0, y:view.center.y, width: UIScreen.main.bounds.width, height: 150), dotSize: 12, labels: labelArray)
        view.addSubview(bounceView)
    }
}

