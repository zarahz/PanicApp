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
    
    @IBOutlet var defaultDesignButton: UIButton!
    @IBOutlet var blueDesignButton: UIButton!
    @IBOutlet var greenDesignButton: UIButton!
    @IBOutlet var redDesignButton: UIButton!
    
    var onRoadImage = UIImage(named: "jellyfish");
    var atHomeImage = UIImage(named: "bubble");
    var delegate: UpdateModeImageProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded menu");
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
    
    @IBAction func thumbsUpButtonPressed(_ sender: Any?) {
        print("thumbs up button pressed")
    }
    
    @IBAction func atHomeClicked(_ sender: Any) {
        delegate?.modeChanged(image: atHomeImage!)    }
    
    @IBAction func onRoadClicked(_ sender: Any) {
        delegate?.modeChanged(image: onRoadImage!)
    }
}

