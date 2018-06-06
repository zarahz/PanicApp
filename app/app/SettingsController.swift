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

class SettingsController: UIViewController, UpdateModeImageProtocol, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    @IBOutlet var modeImage: UIImageView!
    var image = UIImage(named: "bubble");
    var modeChanged: UpdateModeImageProtocol?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        modeChanged(image: image!)
        print("loaded settings");
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let lat = "\(userLocation.coordinate.latitude)"
        let long = "\(userLocation.coordinate.longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                let text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
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
            let nextView = segue.destination as! SettingsMenuController
            nextView.delegate = self
        }
    }
    
    func modeChanged(image: UIImage) {
        modeImage.image = image
    }
}
