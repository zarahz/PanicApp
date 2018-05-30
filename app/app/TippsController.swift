//
//  TippsController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsController: UIViewController {
    
    var bubbles = [BubbleButton]()
    var popupController = UIStoryboard(name: "Main", bundle: nil) .
        instantiateViewController(withIdentifier: "TippsPopup") as? TippsPopupController

     @IBOutlet weak var popupContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createBubbles()
    }
    
    func createBubbles() {
        let viewWidth = Int(self.view.frame.width)
        let viewHeight = Int(self.view.frame.height)
        for _ in 0...9 {
            let bubbleWidth = 50 + Int(arc4random_uniform(100))
            let xPos = Int(arc4random_uniform(UInt32(viewWidth-bubbleWidth)))
            let yPos = Int(arc4random_uniform(UInt32(viewHeight)))
            let bubble = BubbleButton(frame: CGRect(x: xPos, y: yPos, width: bubbleWidth, height: bubbleWidth))
            bubble.addTarget(self, action: #selector(TippsController.showPopup), for: .touchDown)
            bubbles.append(bubble)
            self.view.insertSubview(bubble, at: 0)
        }
    }
    
    @objc func showPopup() {
        guard let popup = self.popupController else {
            fatalError("TippsPopupController couldn't be loaded")
        }
        self.addChildViewController(popup)
        popup.view.frame = popupContainer.frame
        UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: {self.view.addSubview(popup.view)}, completion: nil)
        popup.didMove(toParentViewController: self)
 
    }

}
