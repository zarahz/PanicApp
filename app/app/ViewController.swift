//
//  ViewController.swift
//  app
//
//  Created by Zarah Zahreddin on 24.04.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//


// Homescreen

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var bubbles = [BubbleButton]()
    @IBOutlet var homeView: UIView!
    
    @IBOutlet weak var jellyfishHead: UIImageView!
    @IBOutlet weak var jellyfishTentacles: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        animateJellyfish(delay:0)
        animateButtons()
        createBubbles()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createBubbles() {
        let viewWidth = Int(UIScreen.main.bounds.width)
        let viewHeight = Int(UIScreen.main.bounds.height)
        for _ in 0...5 {
            let bubbleWidth = 20 + Int(arc4random_uniform(100))
            let xPos = Int(arc4random_uniform(UInt32(viewWidth-bubbleWidth)))
            let yPos = Int(arc4random_uniform(UInt32(viewHeight)))
            let bubble = BubbleButton(frame: CGRect(x: xPos, y: yPos, width: bubbleWidth, height: bubbleWidth))
            bubble.addTarget(self, action: #selector(TippsController.pop(_:)), for: .touchDown)
            bubbles.append(bubble)
            self.homeView.insertSubview(bubble, at:0)
            bubble.animate()
        }
    }
    
    func animateJellyfish(delay: Double) {
        
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishTentacles.transform = CGAffineTransform(scaleX: 1, y: 1.08)
        },
                       completion: nil)
        
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        },
                       completion: nil)
        
    }
    
    private func animateButtons() {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.menuButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: nil)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.startButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        },
                       completion: nil)
        
    }

}

