//
//  TippsPopupController.swift
//  app
//
//  Created by Paula Wikidal on 30.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsPopupController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func close(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        print("moved")
        let textView = UITextView()
        textView.text = "Tipp1:\nDas ist der erste Tipp"
        textView.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        textView.layer.cornerRadius = 15
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        textView.isScrollEnabled = false
        stackView.addArrangedSubview(textView)
        print("\(stackView.arrangedSubviews.count)")
    }
    

}
