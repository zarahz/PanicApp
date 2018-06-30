//
//  MenuSingletons.swift
//  app
//
//  Created by Zarah Zahreddin on 29.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    static let shared = Location()
    fileprivate var locationManager = CLLocationManager()
    //MARK: Location variables
    var isUpdatingLocation:Bool!;
    var atHomeModeActive:Bool!;
    var homePosition: CLLocation?
    var userPosition: CLLocation?
    
    //MARK: mode
    var modeImage: UIImage?
    
    override init() {
        super.init()
        atHomeModeActive = false;
        isUpdatingLocation = false;
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType = .fitness
        locationManager.requestAlwaysAuthorization()
        print("init")
    }
    
    //MARK: Locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        if let location = locations.first {
            userPosition = location
        }
        print("\(userLocation) \n")
        
        if (atHomeModeActive && userLocation.horizontalAccuracy <= 10) {
            homePosition = locations.last
            UserDefaults.standard.set(location: homePosition!, forKey: "homeLocation")
            atHomeModeActive = false;
        }
        
        if(homePosition != nil && userLocation.horizontalAccuracy <= 10){
            let distance: CLLocationDistance =
                homePosition!.distance(from: locations.last!)
            if(distance > 15){
                modeImage = UIImage(named: "jellyfish")
                print("left radius")
            }else {
                modeImage = UIImage(named: "bubble")!
            }
            print("\(String(describing: distance)) ------------- HOME POS : \(String(describing: homePosition)) \n")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func setHomeLocation(location: CLLocation){
        homePosition = location;
        getHomeCoordinates(atHomeLocationClicked: false, stop: false)
    }
    
    func getHomeCoordinates(atHomeLocationClicked:Bool, stop:Bool){
            locationManager.stopUpdatingLocation();
            if(!stop){
                //in case User clicked GPS button but home location was already set
                if(homePosition != nil && !atHomeLocationClicked){
                    atHomeModeActive = false;
                }else {
                    atHomeModeActive = true;
                }
                if CLLocationManager.locationServicesEnabled(){
                    locationManager.startUpdatingLocation()
                    isUpdatingLocation = true;
                }
            }
    }
}
