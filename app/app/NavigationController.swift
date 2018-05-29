//
//  NavigationController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }

}
