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
    var counterBreath = 0
    var breathing = false
    var timer5 : Timer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // Do any additional setup after loading the view, typically from a nib.

        self.view.addSubview(myView)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionStart))
        self.myView.addGestureRecognizer(gesture)
    }
    
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
        // audio ausgabe für start und ende und zwischendurch
        motionManager.accelerometerUpdateInterval = 0.4
        print("wir sind in startBreathing")
        //? --> kann wert haben oder nil. ! muss einen wert haben

        
        timer5 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode5), userInfo: nil, repeats: true)

        let date0 = Date()
        var date1 = date0.timeIntervalSinceNow
        var breathIn = true
        
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
            }
        }
    }
    @objc func runTimedCode5(){
        if breathing {
            print("5")//546123
            counterBreath += 1
            if counterBreath%2 == 1{
                print("einatmen")// x 0.05 - 0.07; y -0.11 - -0.15; z -0.98 - -1.0
            } else {
                print("ausatmen")// x0.06 - 0.02; y -0.12
            }
                getData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("5+1")
                    self.getData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("5+1")
                    self.getData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                print("5+1")
                    self.getData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                print("5+1")
                    self.getData()
            }
        }
    }
}
