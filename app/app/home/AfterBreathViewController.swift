//
//  AfterBreathViewController.swift
//  app
//
//  Created by admin on 01.07.18.
//  Copyright © 2018 Katharina Bause. All rights reserved.
//

import UIKit

class AfterBreathViewController: UIViewController {
    var feedbackCounterBreathe = 0.0
    var feedbackCounterError = 0.0
    var fbString = ""

    @IBOutlet weak var data: UILabel!
    
    @IBOutlet weak var feedbackText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()

        //show different feedback based on the error quote
        if(feedbackCounterError/feedbackCounterBreathe > 0.7){
            fbString = "Versuche dich das nächste mal \n mehr zu konzentrieren"
        } else if(feedbackCounterError/feedbackCounterBreathe <= 0.7 && feedbackCounterError/feedbackCounterBreathe > 0.3){
        fbString = "Toll gemacht!"
        } else {
            fbString = "Das war perfekt!"
        }
        data.text = "\(Int(feedbackCounterBreathe) - Int(feedbackCounterError)) von \(Int(feedbackCounterBreathe)) Atemzügen"
        
        feedbackText.text = fbString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        //self.view.removeFromSuperview()s
        feedbackCounterError = 0
        feedbackCounterBreathe = 0
        self.removeAnimate()
    }
    
    //animation by showing the pop up larger and smaller
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        })
    }
}
