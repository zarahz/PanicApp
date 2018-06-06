//
//  HomeController.swift
//  app
//
//  Created by admin on 01.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion


class HomeController: UIViewController {
    var myView = UIView(frame: CGRect(x: 0 , y: 0 , width: 1000 , height: 1000 ))
    var motionManager = CMMotionManager()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // Do any additional setup after loading the view, typically from a nib.

        self.view.addSubview(myView)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionStart))
        self.myView.addGestureRecognizer(gesture)
    }
    @objc func checkActionStart(sender : UITapGestureRecognizer) {
        counter=counter+1;
        if counter % 2 == 1 {
            print("Touched to start")
            self.startBreathing()
        } else {
            print("Touched to end")
        }
        
        
    }

    //MARK: breathing
    func startBreathing(){
        // audio ausgabe für start und ende und zwischendurch
        motionManager.accelerometerUpdateInterval = 0.2
        print("wir sind in startBreathing")
        //? --> kann wert haben oder nil. ! muss einen wert haben
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
            if let myData = data{
                print(myData)
                if myData.acceleration.x > 4.0 {
                    print("The x change is higher than 4.0")
                }
            }
            
        }
        //timeintervalsincenow
        
        
    }
        
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
}
