//
//  AfterBreathViewController.swift
//  app
//
//  Created by admin on 01.07.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class AfterBreathViewController: UIViewController {
    var feedbackCounterBreathe : Int = 0
    var feedbackCounterError : Int = 0

    @IBOutlet weak var data: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //color sind inverted auf Felix' iphone, evtl. muss hier noch black statt white eingefügt werden
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.showAnimate()
        print(feedbackCounterBreathe)
        
        //TODO: percentage im Label anzeigen

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        //self.view.removeFromSuperview()s
        self.removeAnimate()
    }
    

    //Animation über größer/ kleiner
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
