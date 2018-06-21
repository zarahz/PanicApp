//
//  AnimationController.swift
//  app
//
//  Created by Marianne on 12.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class AnimationController: UIViewController {
    @IBOutlet weak var breatheLabel: UILabel!
    @IBOutlet weak var jellyfishHead: UIImageView!
    @IBOutlet weak var jellyfishTentacles: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // LongPressController that calls animation
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchJellyfish))
        jellyfishHead.isUserInteractionEnabled = true
        jellyfishHead.addGestureRecognizer(longPressGesture)
        
        // start default jiggling animation
        animateJellyfish()
        
    }
    
    @objc func touchJellyfish(recognizer:UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // animation for the head to swell

            let swell = UIViewPropertyAnimator(duration: 3, curve: .easeOut, animations: {
                self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            swell.startAnimation()
            
            /* UIView.animate(withDuration: 3,
                           delay: 0,
                           animations: {
                            self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            },
                           completion: nil
            ) */
            
            // change label to 'breathe in'
            breatheLabel.text = "Einatmen..."
            
        case .ended:
            
            // animation for the head to shrink
            let shrink = UIViewPropertyAnimator(duration: 3, curve: .easeOut, animations: {
                self.jellyfishHead.transform = CGAffineTransform.identity
            })
            shrink.startAnimation()
            
            // restart jiggling animation, not very smooth yet
            animateJellyfish()
            
            // change label to 'breathe out'
            breatheLabel.text = "Ausatmen..."
            
        default: break
        }
    }
    
    func animateJellyfish() {
        
        // moves tentacles
            UIView.animate(withDuration: 1,
                       delay: 0.4,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishTentacles.transform = CGAffineTransform(scaleX: 1, y: 1.05)
        },
                       completion: nil)
        
        //repeat same animation for the head
        UIView.animate(withDuration: 1,
                       delay: 0.4,
                       options: [.repeat, .autoreverse, .allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: nil)
        
    }

}

