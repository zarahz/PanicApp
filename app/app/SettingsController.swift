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

protocol SetHomeLocationProtocol {
    func getHomeCoordinates(atHomeLocationClicked: Bool, stop: Bool)
}

class SettingsController: UIViewController, UpdateModeImageProtocol, SetHomeLocationProtocol, CLLocationManagerDelegate {

    //MARK: Location variables
    var locationManager:CLLocationManager!
    var isUpdatingLocation:Bool!;
    var atHomeLocation:Bool!;
    var homePosition: CLLocation?

    //MARK: Mode variables
    var image = UIImage(named: "bubble");
    var jellyfishImage = UIImage(named: "jellyfish");
    var modeChanged: UpdateModeImageProtocol?;
    
    //MARK: Mode Outlets
    @IBOutlet var modeImage: UIImageView!
    
    //MARK:SettingsMenuController
    var menuController:SettingsMenuController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        modeChanged(image: jellyfishImage!)
        //self.menuController?.locationStopDelegate = self;
        
        //locationManager
        atHomeLocation = false;
        isUpdatingLocation = false;
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType = .fitness
        locationManager.requestAlwaysAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("\(userLocation) \n")
        
        if (atHomeLocation && userLocation.horizontalAccuracy <= 10) {
            homePosition = locations.last
            atHomeLocation = false;
        }
        
        if(homePosition != nil && userLocation.horizontalAccuracy <= 10){
            let distance: CLLocationDistance =
                homePosition!.distance(from: locations.last!)
            if(distance > 15){
                modeChanged(image: jellyfishImage!)
                print("left radius")
            }else {
                modeChanged(image: image!)
            }
            print("\(String(describing: distance)) ------------- HOME POS : \(String(describing: homePosition)) \n")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func getHomeCoordinates(atHomeLocationClicked:Bool, stop:Bool){
        
        locationManager.stopUpdatingLocation();
        
        if(!stop){
        //in case User clicked GPS button but home location was already set
        if(homePosition != nil && !atHomeLocationClicked){
            atHomeLocation = false;
        }else {
            atHomeLocation = true;
        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true;
        }
        }
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuContainer" {
            let menuControllerNext = segue.destination as! SettingsMenuController
            menuControllerNext.modeDelegate = self
            menuControllerNext.locationDelegate = self
        }
    }
    
    //MARK: mode
    func modeChanged(image: UIImage) {
        modeImage.image = image
    }
    
}
