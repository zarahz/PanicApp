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
import AVFoundation




class HomeController: UIViewController {
    var myView = UIView(frame: CGRect(x: 0 , y: 0 , width: 1000 , height: 1000 ))
    var motionManager = CMMotionManager()
    var counterStart = 0
    var counterBreath = 1
    var breathing = false
    var timer5 : Timer?
    var breatheIn = true
    var accData = [Double]()
    var accData10 = Array(repeating: 0.0, count: 10)
    var singleData = 0.0
    var index = 0
    var soundIn: AVAudioPlayer!
    
    
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
            
            if timer5 != nil {
                timer5?.invalidate()
                timer5 = nil
                
            }
        }
    }
    
    
    //MARK: breathing
    func startBreathing(){
        // TODO: audio ausgabe für start und ende und zwischendurch
        // mehr Werte --> Durchschnitt bilden und abfragen
        // startUpdate Methode
        motionManager.accelerometerUpdateInterval = 0.2
        print("wir sind in startBreathing")
        //? --> kann wert haben oder nil. ! muss einen wert haben
        getData()
        
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
                self.accData.append(myData.acceleration.x)
            }
        }
    }
    func getAverage() -> Double{
        var tmp = 0.0
        for i in 0...accData.count-1{
            tmp = tmp + accData[i]
        }
        print(tmp/Double(accData.count))
        tmp = tmp/Double(accData.count)
        accData.removeAll()
        return tmp
    }
    
    //if it looks stupid but works, it is not stupid.
    //546123
    //2311
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
            if breatheIn {
                makeSounds(pat: "in-2")
            }
            
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

                print("5+1")
                self.breathingData(index: self.index)
                if self.breatheIn {
                    self.breatheIn = false
                }
            }
            
        }
    }
    func breathingData (index: Int) {
        print(index)
        print(self.breatheIn)
        
        
        if(self.breatheIn && index < 4){
            
            self.accData10[index] = getAverage()
            //beim einatmen ist x steigend. es soll also dem nutzer melden, wenn es fallend ist, um ihn zu korrigieren
            if index > 0{
                if self.accData10[index] <= self.accData10[index-1] {
                //give out some error sound
                    //makeSounds(pat: "error-2")
                }
            }
            
            //breathe out --> ab letztem index bei breathe in und dann alles in breathein false
        } else if self.breatheIn && index == 4{
            makeSounds(pat: "out")
            self.accData10[index] = getAverage()
            
            //breathe out
        } else if !breatheIn {
            self.accData10[index+5] = getAverage()
            //beim ausatmen ist x fallend. es soll also dem nutzer melden, wenn es steigend ist, um ihn zu korrigieren.
            if self.accData10[index+5] >= self.accData10[index+4]{
                //give out some errorsound
                //makeSounds(pat: "error-2")
            }
        }
        self.index += 1
        self.index = self.index%5
        if(!breathing && index == 4){
            motionManager.stopAccelerometerUpdates()
        }
    }
    func makeSounds(pat: String){
        let path = Bundle.main.path(forResource: pat, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            soundIn = try AVAudioPlayer(contentsOf: url)
            soundIn?.play()
        } catch {
            // couldn't load file :(
        }
    }
}

//data while breathing in: x-Achse zunehmend
//data while breathing out: x-Achse abnehmend
