//
//  HomeController.swift
//  app
//
//  Created by admin on 01.06.18.
//  Copyright © 2018 Katharina Bause. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import AVFoundation




class HomeController: UIViewController {
    var motionManager = CMMotionManager()
    var counterStart = 0
    var counterBreath = 1
    var feedbackCounterBreathe = 0.0
    var feedbackCounterError = 0.0
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

    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var GifView: UIImageView!
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var bubbleButton: UIButton!
    @IBOutlet weak var howto: UILabel!
    
    //MARK: build up the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fishesbg0.png")!)
        
        GifView.image = UIImage(named: "fishesframe0")
        
        //Lowers music
        Spotify.shared.changeVolumeTo(volume: 0.5)
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        //sets chosen background
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }

    }
    
    //MARK: tap on THE BUBBLE to start the breathing function
    
    
    @IBAction func bubblePressed(_ sender: Any) {
        makeSounds(pat:"bubble7")
        counterStart=counterStart+1;
        //check if the bubble is pressed multiple times. When pressed the 2./4./6. time, it should end the function
        if counterStart % 2 == 1 {
            bubbleButton.setTitle("Ende", for: UIControlState.normal)
            breathing = true
            
            //hide UI elements that should not be seen while in breathing function
            Switch.isHidden = true
            howto.isHidden = true
            feedbackLabel.isHidden = true
            GifView.loadGif(name: "fishes3")
            self.startBreathing()
        } else {
            
            breathing = false
            bubbleButton.setTitle("Start", for: UIControlState.normal)
            
            if timer5 != nil {
                timer5?.invalidate()
                timer5 = nil
            }
            //show UI elements that should not be seen while in breathing function
            howto.isHidden = false
            feedbackLabel.isHidden = false
            GifView.image = UIImage(named: "fishesframe0")
            Switch.isHidden = false
            showPopUp()
        }
    }
    
    //MARK: breathing
    func startBreathing(){
        motionManager.accelerometerUpdateInterval = 0.2
        getData()
        timer5 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode5), userInfo: nil, repeats: true)
    }

    //retrieve data from the accelerometer
    func getData(){
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
            if let myData = data{
                self.accData.append(myData.acceleration.x)
            }
        }
    }
    
    //get the average out of the last pieces of data in order to eliminate outliers
    func getAverage() -> Double{
        var tmp = 0.0
        for i in 0...accData.count-1{
            tmp = tmp + accData[i]
        }
        tmp = tmp/Double(accData.count)
        accData.removeAll()
        return tmp
    }
    
    //run after 5 seconds
    @objc func runTimedCode5(){

        self.index = 0
        //check if the user tapped a second time in order to stop the exercise
        if breathing {
            //count how many breathes took place in this session for the feedback screen afterwards
            self.feedbackCounterBreathe = self.feedbackCounterBreathe + 1
            
            //check if it is a breathe in or a breathe out
            if counterBreath%2 == 1{
                breatheIn = true
                
                //at every next breathe in/ out, reset the error and increase the errorcounter
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
            
            //run code every second to keep user updated and gain data
            self.breathingData(index: index)
            if breatheIn {
                makeSounds(pat: "inFinal")
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
                //change to breathe out phase
                if self.breatheIn {
                    self.breatheIn = false
                }
            }
        }
    }
    func breathingData (index: Int) {
        
       //////////////////////////IN/////////////////////////////////
        if(self.breatheIn && index < 4){
            self.accData10[index] = getAverage()
            //if setup correctly, the x rises while breathing in. Therefor the user should be notified if it decreases
            if index > 1{
                if self.accData10[index] <= (self.accData10[index-1]+threshold){
                    inError = true
                    //give out some error sound
                    if (Switch.isOn){
                        makeSounds(pat: "bubble2")
                    }
                }
            }
            
            //breathe out --> only 4 seconds breathing in and 6 for breathing out. Therefor the last in must inofficially be an out
        } else if self.breatheIn && index == 4{
            makeSounds(pat: "outFinal")
            self.accData10[index] = getAverage()
            
            
        
            //////////////////////////OUT/////////////////////////////////
        } else if (!breatheIn && index > 5 && index < 9) {
            self.accData10[index+5] = getAverage()
            //while breathing out, x is decreasing. Therefor the user should be informed if it is increasing
            if self.accData10[index+5] >= (self.accData10[index+4]-threshold){
                //give out some errorsound
                outError = true
                print("hier geschieht der out error")
                if (Switch.isOn){
                    makeSounds(pat: "bubble2")
                }
            }
        }
        //setup for next breathe
        self.index += 1
        self.index = self.index%5
        
        if(!breathing && index == 4){
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    //player for the sounds
    func makeSounds(pat: String){
        let path = Bundle.main.path(forResource: pat, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            soundIn = try AVAudioPlayer(contentsOf: url)
            soundIn?.play()
        } catch {
            // couldn't load file
        }
    }
    
    //setup after breathe screen
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//546123
//2311


//data while breathing in: x-Achse zunehmend
//data while breathing out: x-Achse abnehmend
