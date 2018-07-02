//
//  MapViewController.swift
//  app
//
//  Created by Zarah Zahreddin on 22.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController{
    @IBOutlet var mapView: MKMapView!
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getCurrentUserPosition()
        
        if(UserDefaults.standard.location(forKey: "homeLocation") != nil){
        addAnnotationOnLocation(pointedCoordinate: (UserDefaults.standard.location(forKey: "homeLocation")?.coordinate)!);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCurrentUserPosition(){
        if(Location.shared.center != nil){
        let region = MKCoordinateRegion(center: Location.shared.center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func handleLongPress(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizerState.began {
            let touchPoint: CGPoint = (sender as AnyObject).location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addAnnotationOnLocation(pointedCoordinate: newCoordinate)
        }
    }
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D){
        //first delete annotations
        let previousAnnotations = self.mapView.annotations
        if !previousAnnotations.isEmpty{
            self.mapView.removeAnnotation(previousAnnotations[0])
        }
        //create new annotation
        let homeLocation =  CLLocation(latitude: pointedCoordinate.latitude, longitude: pointedCoordinate.longitude)
        UserDefaults.standard.set(location: homeLocation, forKey: "homeLocation");
        Location.shared.setHomeLocation(location: homeLocation)
        
        annotation.coordinate = pointedCoordinate
        annotation.title = "Zu Hause"
        mapView.addAnnotation(annotation)
    }
}


