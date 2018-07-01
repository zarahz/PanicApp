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
    //var myView = UIView(frame: CGRect(x: 0 , y: 0 , width: 1000 , height: 1000 ))
    var motionManager = CMMotionManager()
    var counterStart = 0
    var counterBreath = 1
    var feedbackCounterBreathe = 0
    var feedbackCounterError = 0
    var breathing = false
    var timer5 : Timer?
    var breatheIn = true
    var accData = [Double]()
    var accData10 = Array(repeating: 0.0, count: 10)
    var singleData = 0.0
    var index = 0
    var soundIn: AVAudioPlayer!
    var inError = false
    var outError = false
    let threshold = 0.1

    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var Switch: UISwitch!
    
    //MARK: build up the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //shows current mode
        setupNavigationBar()
        //sets chosen background
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.addSubview(myView)
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionStart))
        //self.myView.addGestureRecognizer(gesture)
        
        let img : UIImage = UIImage(named: "jelly")!
        imageButton.frame = CGRect(x: 0, y: 200, width: 500, height: 500)
        imageButton.setBackgroundImage(img, for: UIControlState.normal)
    }
    
    //MARK: tap on THE PICTURE to start the breathing function
    
    
    @IBAction func checkActionStart(_ sender: Any) {
    //}
    //@objc func checkActionStart(sender : UITapGestureRecognizer) {
        counterStart=counterStart+1;
        if counterStart % 2 == 1 {
            print("Touched to start")
            breathing = true
            print(breathing)
            //wenn der Switch beim starten auf feedback on ist, soll das während der Ausführung nicht mehr verändert werden können
            Switch.isHidden = true
            self.startBreathing()
        } else {
            breathing = false
            print("Touched to end")
            print(breathing)
            
            if timer5 != nil {
                timer5?.invalidate()
                timer5 = nil
            }
            Switch.isHidden = false
            showPopUp()
        }
    }
    
    //? --> kann wert haben oder nil. ! muss einen wert haben
    //UM BACKSLASH ZU MACHEN alt SHIFT 7!!!!!
    
    //MARK: breathing
    func startBreathing(){
        print("wir sind in startBreathing")
        
        motionManager.accelerometerUpdateInterval = 0.2
        //wenn wir kein Feedback wollen, brauchen wir auch keine Daten erheben
        
            getData()
        
        timer5 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode5), userInfo: nil, repeats: true)
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
            //für den Feedback Screen checken, wie oft geatmet wurde in dieser Session
            self.feedbackCounterBreathe = self.feedbackCounterBreathe + 1
            
            //check if it is a breathe in or a breathe out
            if counterBreath%2 == 1{
                breatheIn = true
                if(inError){
                    self.feedbackCounterError = self.feedbackCounterError + 1
                    inError = false
                }
            } else {
                breatheIn = false
                if(outError){
                    self.feedbackCounterError = self.feedbackCounterError + 1
                    outError = false
                }
            }
            counterBreath += 1
            

            self.breathingData(index: index)
            if breatheIn {
                makeSounds(pat: "bubble10")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                self.breathingData(index: self.index)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                self.breathingData(index: self.index)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

                self.breathingData(index: self.index)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {


                self.breathingData(index: self.index)
                if self.breatheIn {
                    self.breatheIn = false
                }
            }
            
        }
    }
    func breathingData (index: Int) {
        //print(index)
        print(self.breatheIn)
        
       //////////////////////////IN///////////////////////////////// indexes 1 bis 3 werden auf errors überprüft
        if(self.breatheIn && index < 4){
            self.accData10[index] = getAverage()
            //beim einatmen ist x steigend. es soll also dem nutzer melden, wenn es fallend ist, um ihn zu korrigieren
            if index > 0{
                if self.accData10[index] <= self.accData10[index-1]+threshold {
                    inError = true
                //give out some error sound
                    if (Switch.isOn){
                        makeSounds(pat: "bubble2")
                    }
                }
            }
            
            //breathe out --> ab letztem index bei breathe in und dann alles in breathein false
        } else if self.breatheIn && index == 4{
            makeSounds(pat: "bubble0")
            
            //der Umschwung der Atmung ist zu unreliable, um Fehler erkennnen zu können --> keine Datenerhebung nötig
            //self.accData10[index] = getAverage()
            
            
            
            //////////////////////////OUT/////////////////////////////////index 5 bis 9
        } else if (!breatheIn) {
            self.accData10[index+5] = getAverage()
            //beim ausatmen ist x fallend. es soll also dem nutzer melden, wenn es steigend ist, um ihn zu korrigieren.
            if self.accData10[index+5] >= self.accData10[index+4]-threshold{
                //give out some errorsound
                if (Switch.isOn){
                    makeSounds(pat: "bubble2")
                }
            }
        }
        self.index += 1
        self.index = self.index%5
        if(!breathing && index == 4){
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    
    func makeSounds(pat: String){
        let path = Bundle.main.path(forResource: pat, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            soundIn = try AVAudioPlayer(contentsOf: url)
            soundIn?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func showPopUp(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "afterBreatheID") as! AfterBreathViewController
        print("Falschatmung \(feedbackCounterError)")
        popOverVC.feedbackCounterBreathe = self.feedbackCounterBreathe
        popOverVC.feedbackCounterError = self.feedbackCounterError
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    //stop breathing function when back is pressed
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            breathing = false
        }
    }
}

//handy unten links, oben rechts: einatmen: x steigend; ausatmen x fallend
//handy oben rechts, unten links: einatmen: x fallend; ausatmen x steigend




//data while breathing in: x-Achse zunehmend
//data while breathing out: x-Achse abnehmend
