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

protocol SettingsProtocol {
    func modeChanged(image: UIImage)
    func changeBackground()
}

class SettingsController: UIViewController, SettingsProtocol{

    //MARK: Mode variables
    var image = UIImage(named: "bubble");
    var jellyfishImage = UIImage(named: "jellyfish");
    var modeChanged: SettingsProtocol?;
    
    //MARK: Mode Outlets
    @IBOutlet var modeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuContainer" {
            let menuControllerNext = segue.destination as! SettingsMenuController
            menuControllerNext.settingsDelegate = self
        }
    }
    
    func changeBackground(){
        let imageName = UserDefaults.standard.string(forKey: "background")! + ".png"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
        print(imageName)
    }
    
    //MARK: mode
    func modeChanged(image: UIImage) {
        modeImage.image = image
    }
    
}
