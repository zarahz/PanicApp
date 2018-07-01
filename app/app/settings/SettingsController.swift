//
//  SettingsController.swift
//  app
//
//  Created by Zarah Zahreddin on 30.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol UpdateModeImageProtocol {
    func modeChanged(image: UIImage)
}

class SettingsController: UIViewController, UpdateModeImageProtocol{

    //MARK: Mode variables
    var image = UIImage(named: "bubble");
    var jellyfishImage = UIImage(named: "jellyfish");
    var modeChanged: UpdateModeImageProtocol?;
    
    //MARK: Mode Outlets
    @IBOutlet var modeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuContainer" {
            let menuControllerNext = segue.destination as! SettingsMenuController
            menuControllerNext.modeDelegate = self
        }
    }
    
    //MARK: mode
    func modeChanged(image: UIImage) {
        modeImage.image = image
    }
    
}
