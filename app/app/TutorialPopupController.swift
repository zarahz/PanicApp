//
//  TutorialPopupController.swift
//  app
//
//  Created by Marianne on 23.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TutorialPopupController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
    }
    

}
