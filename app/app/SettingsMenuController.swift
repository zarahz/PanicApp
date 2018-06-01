//
//  SettingsController.swift
//  app
//
//  Created by Zarah Zahreddin on 18.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit

class SettingsMenuController: UIViewController {
    
    @IBOutlet var atHome: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded settings");
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func test(_ sender: Any) {
        let alertView = UIAlertView()
        alertView.addButton(withTitle: "Ok")
        alertView.title = "My first swift app!!"
        alertView.message = "Hello World"
        alertView.show()
    }
}

