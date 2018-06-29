//
//  BubbleButton.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class BubbleButton: UIButton {
    
    var ovalPath: UIBezierPath!
    
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
    
    @objc func bubbleTapped(button: BubbleButton, event: UIEvent) {
        if let touch = event.touches(for: button)?.first {
            let location = touch.location(in: button)
            if ovalPath.contains(location) == false {
                button.cancelTracking(with: nil)
            } else {
                makeSounds(pat:)
            }
        }
    }
    
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
        let path = Bundle.main.path(forResource: pat, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            soundIn = try AVAudioPlayer(contentsOf: url)
            soundIn?.play()
        } catch {
            // couldn't load file :(
        }
    }
}
