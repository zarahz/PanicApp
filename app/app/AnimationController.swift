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
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var spotifyButton: UIButton!
    @IBOutlet var animationView: UIView!
    
    let defText = "Einatmen..."
    let breatheText = "Ausatmen.."
    let red = UIColor(red:1.00, green:0.49, blue:0.49, alpha:1.0)
    let breatheIn = 3.0
    let breatheOut = 4.0
    
    var fillColor = UIViewPropertyAnimator()
    var removeColor = UIViewPropertyAnimator()
    var bubbles = [BubbleButton]()
    
    var popupController = UIStoryboard(name: "Main", bundle: nil) .
        instantiateViewController(withIdentifier: "TutorialPopup") as? TutorialPopupController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createBubbles()
        
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        //sets chosen background
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
        
        // LongPressController that calls animation
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchJellyfish))
        jellyfishHead.isUserInteractionEnabled = true
        jellyfishHead.addGestureRecognizer(longPressGesture)
        
        // Touch for Spotify shortcut
        spotifyButton.addTarget(self, action: #selector(self.spotifyAction), for: .touchDown)
        
        // Touch for Tutorial popup
        tutorialButton.addTarget(self, action: #selector(self.showTutorial), for: .touchDown)
        
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
                            self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                            self.jellyfishRed.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
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
    
    
    // open popup to show tutorial
    @objc func showTutorial () {
        
        self.addChildViewController(popupController!)
        popupController?.view.frame = self.view.frame
        self.view.addSubview((popupController?.view)!)
        popupController?.didMove(toParentViewController: self)
        
    }
    
    
    // call Spotify shortcut with play and pause
    @objc func spotifyAction () {
        
        if( UserDefaults.standard.integer(forKey:"loggedIn") == 1){
        Spotify.shared.pausePlayer()
        }

    }
    
    
    // animates tentacles
    func animateTentacles(delay: Double) {
        
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishTentacles.transform = CGAffineTransform(scaleX: 1, y: 1.05)
        },
                       completion: nil)
        
    }
    
    // animates head
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
    private func fadeIn (dur: Double, del: Double, obj: UILabel, text: String) {
        
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
    private func fadeOut (dur: Double, del: Double, obj: UILabel) {
        
        UIView.animate(withDuration: dur,
                       delay: del,
                       animations: {
                        obj.alpha = 0.0
        },
                       completion: { (finished:Bool) in self.fadeIn(dur:1, del:1, obj:obj, text:self.defText)}
        )
        
    }
    
    // creates bubbles in background
    private func createBubbles() {
        let viewWidth = Int(UIScreen.main.bounds.width)
        let viewHeight = Int(UIScreen.main.bounds.height)
        for _ in 0...5 {
            let bubbleWidth = 50 + Int(arc4random_uniform(100))
            let xPos = Int(arc4random_uniform(UInt32(viewWidth-bubbleWidth)))
            let yPos = Int(arc4random_uniform(UInt32(viewHeight)))
            let bubble = BubbleButton(frame: CGRect(x: xPos, y: yPos, width: bubbleWidth, height: bubbleWidth))
            bubble.addTarget(self, action: #selector(TippsController.pop(_:)), for: .touchDown)
            bubbles.append(bubble)
            self.animationView.insertSubview(bubble, at:0)
            bubble.animate()
        }
    }
    
    
    
}
