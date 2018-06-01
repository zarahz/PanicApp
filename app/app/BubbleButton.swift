//
//  BubbleButton.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

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
    }
    
    @objc func bubbleTapped(button: BubbleButton, event: UIEvent) {
        if let touch = event.touches(for: button)?.first {
            let location = touch.location(in: button)
            
            if ovalPath.contains(location) == false {
                button.cancelTracking(with: nil)
            } else {
            }
        }
    }
}
