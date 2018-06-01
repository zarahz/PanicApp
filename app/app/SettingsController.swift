//
//  SettingsController.swift
//  app
//
//  Created by Zarah Zahreddin on 30.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateModeImageProtocol {
    func modeChanged(image: UIImage)
}

class SettingsController: UIViewController, UpdateModeImageProtocol {
    
    @IBOutlet var modeImage: UIImageView!
    var image = UIImage(named: "bubble");
    var modeChanged: UpdateModeImageProtocol?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        modeChanged(image: image!)
        print("loaded settings");
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuContainer" {
            let nextView = segue.destination as! SettingsMenuController
            nextView.delegate = self
        }
    }
    
    func modeChanged(image: UIImage) {
        modeImage.image = image
    }
}
