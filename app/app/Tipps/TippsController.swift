//
//  TippsController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsController: UIViewController, UITextFieldDelegate {
    
    var bubbles = [BubbleButton]()
    var tipps = [Tipp]()
    var popupController: TippsPopupController?
    
    
    @IBOutlet weak var tippView: UIView!
    @IBOutlet weak var tippHeading: UILabel!
    @IBOutlet weak var tippContent: UILabel!
    
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createBubbles()
        loadTipps()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popupController = segue.destination as? TippsPopupController {
            self.popupController = popupController
            popupController.delegate = self
        }
    }
    
    func createBubbles() {
        let viewWidth = Int(self.view.frame.width)
        let viewHeight = Int(self.view.frame.height)
        for _ in 0...9 {
            let bubbleWidth = 50 + Int(arc4random_uniform(100))
            let xPos = Int(arc4random_uniform(UInt32(viewWidth-bubbleWidth)))
            let yPos = Int(arc4random_uniform(UInt32(viewHeight)))
            let bubble = BubbleButton(frame: CGRect(x: xPos, y: yPos, width: bubbleWidth, height: bubbleWidth))
            bubble.addTarget(self, action: #selector(TippsController.showRandomTipp), for: .touchDown)
            bubbles.append(bubble)
            self.view.insertSubview(bubble, at: 0)
        }
    }
    
    @objc func showRandomTipp() {
        print("random tipp")
        
        let randomIndex = Int(arc4random_uniform(UInt32(tipps.count)))
        tippHeading.text = popupController!.tipps[randomIndex].heading
        tippContent.text = popupController!.tipps[randomIndex].content
        
        tippView.isHidden = false
    }
    
    @IBAction func closeTipp(_ sender: UIButton) {
        tippView.isHidden = true
    }
    
    func closePopup() {
        popupContainer.isHidden = true
    }
    
    func showPopup() {
        print("show popup")
        tippView.isHidden = true
        guard let popup = self.popupController else {
            fatalError("TippsPopupController couldn't be loaded")
        }
        UIView.animate(withDuration:0.2, animations: {popup.view.frame.origin.y = self.popupContainer.frame.origin.y},
                       completion: nil)
        popupContainer.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        showPopup()
        popupController!.showSearchResult(searchQuery: textField.text)
    }
    
    private func loadTipps() {
        let tippsListURL: URL = URL(fileURLWithPath:Bundle.main.path(forResource:"tippsList", ofType: "plist")!)
        
        do {
            let data = try Data(contentsOf: tippsListURL)
            let decoder = PropertyListDecoder()
            self.tipps = try decoder.decode([Tipp].self, from: data)
        } catch {
            print(error)
        }
        
    }
    
}
