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
    
    var atHomeModeActive:Bool!;
    var homePosition: CLLocation?
    var userPosition: CLLocation?

    //MARK: mode
    var modeImage: UIImage?

    var center: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        atHomeModeActive = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType = .fitness
        locationManager.requestAlwaysAuthorization()
    }
    
    //MARK: Locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        print("\(userLocation) \n")
        
        center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

        
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
                modeImage = UIImage(named: "bubble")
            }
            print("\(String(describing: distance)) ------------- HOME POS : \(String(describing: homePosition)) \n")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func trackLocations(setCurrentPositionHome:Bool){
        //in case User clicked GPS button but home location was already set
        if(homePosition != nil && !setCurrentPositionHome){
            atHomeModeActive = false;
        }else {
            atHomeModeActive = true;
        }
        startGPS()
    }
    
    func startGPS(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopGPS(){
        locationManager.stopUpdatingLocation();
    }
    
    func setHomeLocation(location: CLLocation){
        homePosition = location;
        trackLocations(setCurrentPositionHome: false)
    }
}
