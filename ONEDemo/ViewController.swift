//
//  ViewController.swift
//  ONEDemo
//
//  Created by clearlove on 2017/7/4.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {

    lazy var ballsArr = Array<Any>()
    var gravity:UIGravityBehavior?
    var collision:UICollisionBehavior? //碰撞
    var animator:UIDynamicAnimator? //动态图
    var motionManager:CMMotionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 130, y: 30, width: 80, height: 80)
        button.setTitle("开始", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
        view.addSubview(button)
    }

    func click(button:UIButton) {
        if ballsArr.count > 0 {
            ballsArr.removeAll()
        }
       
        setBalls()
//        button.removeFromSuperview()
    }
    
    func setBalls() {
        for _ in 0 ..< 30 {
            
            let ball = UIView()
            let red = CGFloat(arc4random()%256) / 255.0
            let green = CGFloat(arc4random()%256) / 255.0
            let blue = CGFloat(arc4random()%256) / 255.0
            
            ball.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            let x = arc4random() % UInt32( (self.view.bounds.size.width - 40))

            let ballsFrame = CGRect(x: Int(x), y: 0, width: 40, height: 40)
            ball.frame = ballsFrame
            ball.layer.cornerRadius = 20.0
            view.addSubview(ball)
            ballsArr.append(ball)
            
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: ballsArr as! [UIDynamicItem])
        
        animator?.addBehavior(gravity!)
        
        collision = UICollisionBehavior(items: ballsArr as! [UIDynamicItem])
        collision?.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collision!)
        
        let dynamicItemBehavior = UIDynamicItemBehavior(items: ballsArr as! [UIDynamicItem])
        dynamicItemBehavior.elasticity = 1
        animator?.addBehavior(dynamicItemBehavior)
        
        motionManager = CMMotionManager()
        motionManager?.startDeviceMotionUpdates(to: OperationQueue(), withHandler: { (motion, error) in
            
            let rotation:Double = atan2((motion?.attitude.pitch)!, (motion?.attitude.roll)!)
            self.gravity?.angle = CGFloat(rotation)
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

