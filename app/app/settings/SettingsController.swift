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
    func changeBackground()
}

class SettingsController: UIViewController, SettingsProtocol{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        //sets chosen background
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
            let menuController = segue.destination as! SettingsMenuController
            menuController.settingsDelegate = self
        }
    }
    
    func changeBackground(){
        let imageName = UserDefaults.standard.string(forKey: "background")! + ".png"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
        print(imageName)
    }
    
}
