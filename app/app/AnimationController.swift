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
    @IBOutlet weak var jellyfishRed: UIImageView!
    @IBOutlet weak var spotify: UIImageView!
    @IBOutlet weak var tutorial: UIImageView!
    
    let defText = "Einatmen..."
    let breatheText = "Ausatmen..."
    let red = UIColor(red:1.00, green:0.49, blue:0.49, alpha:1.0)
    let breatheIn = 3.0
    let breatheOut = 4.0
    
    var fillColor = UIViewPropertyAnimator()
    var removeColor = UIViewPropertyAnimator()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // LongPressController that calls animation
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchJellyfish))
        jellyfishHead.isUserInteractionEnabled = true
        jellyfishHead.addGestureRecognizer(longPressGesture)
        
        // start default jiggling animation
        animateTentacles(delay:0.4)
        animateHead(delay:0.6)

        
    }
    
    @objc func touchJellyfish(recognizer:UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // animation for the head to swell
            UIView.animate(withDuration: breatheIn,
                           delay: 0,
                           animations: {
                            self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            self.jellyfishRed.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            },
                           completion: nil
            )
            
            // change label to 'breathe in'
            breatheLabel.text = self.defText
            
            // label fade out at the end
            UIView.animate(withDuration: 1,
                           delay: breatheIn,
                           animations: {
                            self.breatheLabel.alpha = 0.0
                            },
                           completion: nil
            )
            
            // color head in red with overlay
            fillColor = UIViewPropertyAnimator(duration: 5, curve: .easeOut, animations: {
                self.jellyfishRed.alpha = 0.8
            })
            fillColor.startAnimation(afterDelay: breatheIn)

            
        case .ended:
            
            // remove red color
            fillColor.stopAnimation(true)
            removeColor = UIViewPropertyAnimator(duration:1, curve: .easeOut, animations: {
                self.jellyfishRed.alpha = 0
            })
            removeColor.startAnimation()
            
            // animation for the head to shrink
            UIView.animate(withDuration: breatheOut,
                           delay: 0,
                           animations: {
                            self.jellyfishHead.transform = CGAffineTransform.identity
                            self.jellyfishRed.transform = CGAffineTransform.identity
            },
                           completion: {(finished: Bool) in self.animateHead(delay: 0.4)}
            )
            
            // change label to 'breathe out'
            breatheLabel.text = self.breatheText
            
            // fade label in at the beginning and out in the end
            UIView.animate(withDuration: 1,
                           delay: 0,
                           animations: {
                            self.breatheLabel.alpha = 1.0
            },
                           completion: { (finished: Bool) in self.fadeOut(dur:1, del:self.breatheOut, obj:self.breatheLabel)}
            )
            

            
        default: break
        }
    }
    
    func animateTentacles(delay: Double) {
        
            UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishTentacles.transform = CGAffineTransform(scaleX: 1, y: 1.05)
        },
                       completion: nil)
        
    }
    
    func animateHead(delay: Double) {
        
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        },
                       completion: nil)
        
    }
    
    
    // fades text in and sets new text
    func fadeIn (dur: Double, del: Double, obj: UILabel, text: String) {
        
        UIView.animate(withDuration: dur,
                       delay: del,
                       animations: {
                        self.breatheLabel.text = text
                        obj.alpha = 1.0
        },
                       completion: nil
        )
        
    }
    
    
    // fades text out and right back in
    func fadeOut (dur: Double, del: Double, obj: UILabel) {
        
        UIView.animate(withDuration: dur,
                       delay: del,
                       animations: {
                        obj.alpha = 0.0
        },
                       completion: { (finished:Bool) in self.fadeIn(dur:1, del:1, obj:obj, text:self.defText)}
        )
        
    }
    
    

}


