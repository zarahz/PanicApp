//
//  ViewController.swift
//  app
//
//  Created by Zarah Zahreddin on 24.04.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//


// Homescreen

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var soundIn: AVAudioPlayer!

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var bubbles = [BubbleButton]()
    @IBOutlet var homeView: UIView!
    
    @IBOutlet weak var jellyfishHead: UIImageView!
    @IBOutlet weak var jellyfishTentacles: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        //sets chosen background
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
             print(imageName)
        }
        // Do any additional setup after loading the view, typically from a nib.
        print("start")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //shows current mode
        setupNavigationBar()
        Location.shared.viewController = self
        if(UserDefaults.standard.string(forKey: "background") != nil){
            let imageName = (UserDefaults.standard.string(forKey: "background"))! + ".png"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
            print(imageName)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        animateJellyfish(delay:0)
        animateButtons()
        createBubbles()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        jellyfishHead.transform = CGAffineTransform(scaleX: 1, y: 1)
        jellyfishTentacles.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        menuButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        startButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Buttons sollen sounds ergeben
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("start tapped")
        makeSounds(pat: "bubble1")
    }
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        makeSounds(pat: "bubble2")
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
    
    //distinguish mode on start
    @IBAction func start(_ sender: Any) {
        if(getMode() == 0){
            self.performSegue(withIdentifier: "startToJelly", sender: nil)
        }else{
            self.performSegue(withIdentifier: "startToHome", sender: nil)
        }
    }

    private func createBubbles() {
        let viewWidth = Int(UIScreen.main.bounds.width)
        let viewHeight = Int(UIScreen.main.bounds.height)
        for _ in 0...5 {
            let bubbleWidth = 20 + Int(arc4random_uniform(100))
            let xPos = Int(arc4random_uniform(UInt32(viewWidth-bubbleWidth)))
            let yPos = Int(arc4random_uniform(UInt32(viewHeight)))
            let bubble = BubbleButton(frame: CGRect(x: xPos, y: yPos, width: bubbleWidth, height: bubbleWidth))
            bubble.addTarget(self, action: #selector(TippsController.pop(_:)), for: .touchDown)
            bubbles.append(bubble)
            self.homeView.insertSubview(bubble, at:0)
            bubble.animate()
        }
    }
    
    func animateJellyfish(delay: Double) {
        
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishTentacles.transform = CGAffineTransform(scaleX: 1, y: 1.08)
        },
                       completion: nil)
        
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: [.repeat, .autoreverse, .beginFromCurrentState],
                       animations: {
                        self.jellyfishHead.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        },
                       completion: nil)
        
    }
    
    private func animateButtons() {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.menuButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: nil)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.startButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        },
                       completion: nil)
        
    }

}

