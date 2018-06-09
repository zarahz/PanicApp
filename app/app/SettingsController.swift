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

class SettingsController: UIViewController, UpdateModeImageProtocol, SetHomeLocationProtocol, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var atHomeClicked:Bool!;
    var homePosition: CLLocation?
    
    @IBOutlet var modeImage: UIImageView!
    var image = UIImage(named: "bubble");
    var jellyfishImage = UIImage(named: "jellyfish");
    var modeChanged: UpdateModeImageProtocol?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        modeChanged(image: jellyfishImage!)
        print("loaded settings");
        
        atHomeClicked = false;
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //locationManager.distanceFilter = 1
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("\(userLocation) \n")
        
        if (atHomeClicked && userLocation.horizontalAccuracy <= 10) {
            homePosition = locations.last
            atHomeClicked = false;
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuContainer" {
            let menuControllerNext = segue.destination as! SettingsMenuController
            menuControllerNext.modeDelegate = self
            menuControllerNext.locationDelegate = self
        }
    }
    
    func modeChanged(image: UIImage) {
        modeImage.image = image
    }
    
    func getHomeCoordinates(){
        atHomeClicked = true;
    }
}
