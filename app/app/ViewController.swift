//
//  ViewController.swift
//  app
//
//  Created by Zarah Zahreddin on 24.04.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    var soundIn: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // Do any additional setup after loading the view, typically from a nib.
        print("start")
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
}

