//
//  TippsController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsController: UIViewController, UISearchBarDelegate {
    
    var bubbles = [BubbleButton]()
    var tipps = [Tipp]()
    var popupController: TippsPopupController?
    
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var tippView: UIView!
    @IBOutlet weak var tippHeading: UILabel!
    @IBOutlet weak var tippContent: UILabel!
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var popupContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        tippView.layer.shadowColor = UIColor.black.cgColor
        tippView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tippView.layer.shadowOpacity = 1.0
        tippView.layer.shadowRadius = 8.0
        
        searchField.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createBubbles()
        loadTipps()
    }
    
    @objc func keyboardChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardY = keyboardRect?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(truncating: animationCurveRawNSN!)),
                           animations: { self.view.frame.size.height = keyboardY},
                           completion: nil)
        }
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
            self.bubbleView.insertSubview(bubble, at:0)
        }
    }
    
    @objc func showRandomTipp() {
        let randomIndex = Int(arc4random_uniform(UInt32(tipps.count)))
        tippHeading.text = popupController!.tipps[randomIndex].heading
        tippContent.text = popupController!.tipps[randomIndex].content
        
        tippView.isHidden = false
        view.bringSubview(toFront: tippView)
    }
    
    @IBAction func closeTipp() {
        tippView.isHidden = true
        view.sendSubview(toBack: tippView)
    }
    
    func closePopup() {
        popupContainer.isHidden = true
    }
    
    func showPopup() {
        guard let popup = self.popupController else {
            fatalError("TippsPopupController couldn't be loaded")
        }
        popup.view.frame.origin.y = view.frame.height
        UIView.animate(withDuration:0.2, animations: {popup.view.frame.origin.y = self.popupContainer.frame.origin.y},
                       completion: nil)
        popupContainer.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        closeTipp()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
        if let searchQuery = searchBar.text {
            if !searchQuery.isEmpty {
                showPopup()
                popupController!.showSearchResult(searchQuery: searchQuery)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Display results while still typing?
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
