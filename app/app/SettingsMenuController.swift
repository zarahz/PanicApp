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
    
    var onRoadImage = UIImage(named: "jellyfish");
    var atHomeImage = UIImage(named: "bubble");
    var delegate: UpdateModeImageProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded settings");
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func atHomeClicked(_ sender: Any) {
        delegate?.modeChanged(image: atHomeImage!)    }
    
    @IBAction func onRoadClicked(_ sender: Any) {
        delegate?.modeChanged(image: onRoadImage!)
    }
}

