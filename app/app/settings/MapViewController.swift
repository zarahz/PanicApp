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
    var locationDelegate: HomeLocationProtocol!

    let regionRadius: CLLocationDistance = 1000
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in Honolulu location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location:initialLocation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func handleLongPress(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizerState.began {
            let touchPoint: CGPoint = (sender as AnyObject).location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addAnnotationOnLocation(pointedCoordinate: newCoordinate)
        }
    }
    
    func addAnnotationOnLocation(pointedCoordinate: CLLocationCoordinate2D){
        let homeLocation =  CLLocation(latitude: pointedCoordinate.latitude, longitude: pointedCoordinate.longitude)

        locationDelegate?.setHomeLocation(location: homeLocation)
        annotation.coordinate = pointedCoordinate
        annotation.title = "Zu Hause"
        mapView.addAnnotation(annotation)
    }
}

