//
//  NavigationController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes background transparent
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }

}
