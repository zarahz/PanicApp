//
//  SettingsController.swift
//  app
//
//  Created by Zarah Zahreddin on 18.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit

protocol SetHomeLocationProtocol: class {
    func getHomeCoordinates()
}

class SettingsMenuController: UIViewController {
    
    weak var locationDelegate: SetHomeLocationProtocol?
    
    @IBOutlet var defaultDesignButton: UIButton!
    @IBOutlet var blueDesignButton: UIButton!
    @IBOutlet var greenDesignButton: UIButton!
    @IBOutlet var redDesignButton: UIButton!
    
    @IBOutlet var setHomeLocationButton: UIButton!
    @IBOutlet var homeLocationButton: UIButton!
    
    var onRoadImage = UIImage(named: "jellyfish");
    var atHomeImage = UIImage(named: "bubble");
    var modeDelegate: UpdateModeImageProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded menu");

        adjustTextSize(homeLocationButton);
        adjustTextSize(setHomeLocationButton);
        
        shapeDesignButton(defaultDesignButton);
        shapeDesignButton(blueDesignButton);
        shapeDesignButton(greenDesignButton);
        shapeDesignButton(redDesignButton);
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func shapeDesignButton(_ button:UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(SettingsMenuController.thumbsUpButtonPressed(_:)), for: .touchUpInside)
        //view.addSubview(button)
    }
    
    func adjustTextSize(_ button:UIButton){
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
   @IBAction func thumbsUpButtonPressed(_ sender: Any?) {
        print("thumbs up button pressed")
    }
    
    @IBAction func atHomeClicked(_ sender: Any) {
        modeDelegate?.modeChanged(image: atHomeImage!)    }
    
    @IBAction func onRoadClicked(_ sender: Any) {
        modeDelegate?.modeChanged(image: onRoadImage!)
    }
 
    @IBAction func homeLocationClicked(_ sender: Any) {
        locationDelegate?.getHomeCoordinates();
    }
    
}

