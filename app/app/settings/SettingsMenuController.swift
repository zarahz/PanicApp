//
//  SettingsController.swift
//  app
//
//  Created by Zarah Zahreddin on 18.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SettingsMenuController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: protocols
    var locationDelegate: HomeLocationProtocol?
    var modeDelegate: UpdateModeImageProtocol!
    
    //MARK: Design button outlets
    @IBOutlet var defaultDesignButton: UIButton!
    @IBOutlet var blueDesignButton: UIButton!
    @IBOutlet var greenDesignButton: UIButton!
    @IBOutlet var redDesignButton: UIButton!
    
    //MARK: Location Button outlets
    @IBOutlet var setHomeLocationButton: UIButton!
    @IBOutlet var homeLocationButton: UIButton!
    
    //MARK: Mode button outlets
    @IBOutlet var onRoadMode: UIButton!
    @IBOutlet var atHomeMode: UIButton!
    @IBOutlet var GPSMode: UIButton!
    var onRoadImage = UIImage(named: "jellyfish");
    var atHomeImage = UIImage(named: "bubble");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded menu");
        
        //make design button circled
        shapeDesignButton(defaultDesignButton);
        shapeDesignButton(blueDesignButton);
        shapeDesignButton(greenDesignButton);
        shapeDesignButton(redDesignButton);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Mode Click Handler
    @IBAction func atHomeClicked(_ sender: Any) {
        locationDelegate?.getHomeCoordinates(atHomeLocationClicked: false, stop: true);
        highlightClickedButton(atHomeMode)
        normalizeButton(onRoadMode)
        normalizeButton(GPSMode)
        modeDelegate?.modeChanged(image: atHomeImage!)
    }
    
    @IBAction func onRoadClicked(_ sender: Any) {
        locationDelegate?.getHomeCoordinates(atHomeLocationClicked: false, stop: true);
        highlightClickedButton(onRoadMode)
        normalizeButton(atHomeMode)
        normalizeButton(GPSMode)
        modeDelegate?.modeChanged(image: onRoadImage!)
    }
    
    @IBAction func activateGPS(_ sender: Any) {
    locationDelegate?.getHomeCoordinates(atHomeLocationClicked: false, stop: false);
        normalizeButton(homeLocationButton)
        normalizeButton(atHomeMode)
        normalizeButton(onRoadMode)
        highlightClickedButton(GPSMode)
    }
    //function that is called when map sets home location
    func setHomeLocation(location: CLLocation){
        locationDelegate?.setHomeLocation(location: location)
        activateGPS((Any).self);
    }
    
    @IBAction func homeLocationClicked(_ sender: Any) {
    locationDelegate?.getHomeCoordinates(atHomeLocationClicked: true, stop: false);
        highlightClickedButton(GPSMode);
        normalizeButton(homeLocationButton)
        normalizeButton(onRoadMode)
        normalizeButton(atHomeMode)
    }
    
    //MARK: Design Button functions
    func shapeDesignButton(_ button:UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(SettingsMenuController.thumbsUpButtonPressed(_:)), for: .touchUpInside)
        //view.addSubview(button)
    }
    
    @IBAction func thumbsUpButtonPressed(_ sender: Any?) {
        print("thumbs up button pressed")
    }
    
    //MARK: Helper functions
    func adjustTextSize(_ button:UIButton){
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    func highlightClickedButton(_ button:UIButton){
        button.setTitleColor(UIColor(red: 111.0/255.0, green: 127.0/255.0, blue: 166.0/255.0,alpha:1), for: .normal);
    }
    
    func normalizeButton(_ button:UIButton){
        button.setTitleColor(UIColor.black, for: .normal);
        button.alpha = 0.8;
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map" {
            let mapControllerNext = segue.destination as! MapViewController
            mapControllerNext.menuController = self
        }
    }
}

