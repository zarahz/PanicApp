//
//  MenuController.swift
//  app
//
//  Created by Marianne on 29.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
    }
    
}
