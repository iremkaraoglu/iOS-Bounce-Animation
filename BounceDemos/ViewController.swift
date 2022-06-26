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
        addDot()
    }


    func addDot() {
        let ball = UIView()
        ball.frame = CGRect(x: view.center.x, y: view.center.y, width:  UIDevice.current.userInterfaceIdiom == .pad ? 18 : 12, height:  UIDevice.current.userInterfaceIdiom == .pad ? 18 : 12)
        ball.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 9 : 6
        ball.backgroundColor = .white
        view.addSubview(ball)
    }
    
}

