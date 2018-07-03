//
//  MenuController.swift
//  app
//
//  Created by Marianne on 29.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    var bubbles = [BubbleButton]()
    @IBOutlet var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        //sets chosen background
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Spotify.shared.changeVolumeTo(volume: 1)
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
        createBubbles()
    }
    
    
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
            self.menuView.insertSubview(bubble, at:0)
            bubble.animate()
        }
    }
    
}
