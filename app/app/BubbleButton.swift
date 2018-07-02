//
//  BubbleButton.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit
import AVFoundation
import Darwin

@IBDesignable class BubbleButton: UIButton {
    
    // MARK: Properties
    var ovalPath: UIBezierPath!
    var soundpaths = ["bubble0", "bubble1", "bubble2", "bubble3", "bubble4", "bubble5", "bubble6", "bubble7", "bubble8", "bubble9", "bubble10"]
    var soundIn: AVAudioPlayer!
    
    // MARK: Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.setBackgroundImage(UIImage(named: "bubble"), for: .normal)
        self.setTitle("", for: .normal)
        addTarget(self, action: #selector(BubbleButton.bubbleTapped(button:event:)), for: .touchDown)
        adjustsImageWhenHighlighted = false
        showsTouchWhenHighlighted = false
    }
    
    // Only register taps inside circular area
    @objc func bubbleTapped(button: BubbleButton, event: UIEvent) {
        
        //one of the random bubble sounds should be played when tapped on the right position in the screen
        let randomIndex = Int(arc4random_uniform(10))
        //let randomIndex = Int.random(in: 0..<10)
        let path = soundpaths[randomIndex]
        makeSounds(pat:path)
        if let touch = event.touches(for: button)?.first {
            let location = touch.location(in: button)
            if ovalPath.contains(location) == false {
                button.cancelTracking(with: nil)
            }
        }
    }
    
    // MARK: Animation
    func animate() {
        let yPos = self.frame.origin.y
        let duration = 20.0+Double(arc4random_uniform(10))
        let yDistance = UIScreen.main.bounds.height + 250
        let firstDuration = Double((yPos+250)/yDistance) * duration
        UIView.animate(withDuration: firstDuration, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
            self.frame.origin.y = -250
        }, completion: {_ in self.animateFromBottom()}
        )
    }
    
    private func animateFromBottom() {
        self.frame.origin.y = UIScreen.main.bounds.height
        let duration = 20.0+Double(arc4random_uniform(10))
        let delay = Double(arc4random_uniform(5))
        UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction, .curveLinear, .repeat], animations: {
            self.frame.origin.y = -250
        }, completion: nil
        )
    }
    
    func makeSounds(pat: String){
        let path = Bundle.main.path(forResource: pat, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            soundIn = try AVAudioPlayer(contentsOf: url)
            soundIn?.play()
        } catch {
            // couldn't load file :(
        }
    }
}
