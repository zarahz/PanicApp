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
    var counterStart = 0
    var counterBreath = 1
    var breathing = false
    var timer5 : Timer!
    var breatheIn = true
    var accData = Array(repeating: 0.0, count: 10)
    var singleData = 0.0
    var index = 0
    
    
    //MARK: build up the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(myView)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionStart))
        self.myView.addGestureRecognizer(gesture)
    }
    
    //MARK: tap on screen to start the breathing function
    @objc func checkActionStart(sender : UITapGestureRecognizer) {
        counterStart=counterStart+1;
        if counterStart % 2 == 1 {
            print("Touched to start")
            breathing = true
            print(breathing)
            self.startBreathing()
        } else {
            breathing = false
            print("Touched to end")
            print(breathing)
        }
    }
    
    
    //MARK: breathing
    func startBreathing(){
        // TODO: audio ausgabe für start und ende und zwischendurch
        motionManager.accelerometerUpdateInterval = 0.4
        print("wir sind in startBreathing")
        //? --> kann wert haben oder nil. ! muss einen wert haben
        
        
        timer5 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode5), userInfo: nil, repeats: true)
        
        let date0 = Date()
        var date1 = date0.timeIntervalSinceNow
        
        
        //UM BACKSALSH ZU MACHEN alt SHIFT 7!!!!!
        /*while (breathing){
         while date1 > -4.0 && breathing{
         date1 = date0.timeIntervalSinceNow
         breathIn = true;
         print("breathing in \(date1)")
         }
         while date1 > -10.0 && breathing {
         date1 = date0.timeIntervalSinceNow
         breathIn = false
         print("breathing out\(date1)")
         }
         date1 = 0.0
         
         }*/
        //timeintervalsincenow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
            if let myData = data{
                print(myData)
                self.singleData = myData.acceleration.x
            }
        }
    }
    //if it looks stupid but works, it is not stupid.
    //546123
    @objc func runTimedCode5(){
        self.index = 0
        //check if the user tapped a second time in order to stop the exercise
        if breathing {
            
            //check if it is a breathe in or a breathe out
            if counterBreath%2 == 1{
                breatheIn = true
                //print("einatmen")// x 0.05 - 0.07; y -0.11 - -0.15; z -0.98 - -1.0
            } else {
                breatheIn = false
                //print("ausatmen")// x0.06 - 0.02; y -0.12
            }
            counterBreath += 1
            
            print("5")
            self.breathingData(index: index)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("5+1")
                self.breathingData(index: self.index)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("5+1")
                self.breathingData(index: self.index)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                print("5+1")
                self.breathingData(index: self.index)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                if self.breatheIn {
                    self.breatheIn = false
                }
                print("5+1")
                self.breathingData(index: self.index)
                
            }
            
        }
    }
    func breathingData (index: Int) {
        print(index)
        print(self.breatheIn)
        self.getData()
        if(self.breatheIn){
            self.accData[index] = self.singleData
        } else{
            self.accData[index+5] = self.singleData
        }
        self.index += 1
        self.index = self.index%5
    }
}

//data while breathing in: x-Achse zunehmend
//data while breathing out: x-Achse abnehmend
