//
//  TippsController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit
import ApiAI

class TippsController: UIViewController, UISearchBarDelegate {
    
    var bubbles = [BubbleButton]()
    var tipps = [Message]()
    var popupController: TippsPopupController!
    var chatBotIsActive = false
    
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var tippView: UIView!
    @IBOutlet weak var tippHeading: UILabel!
    @IBOutlet weak var tippContent: UILabel!
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var popupContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        searchField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        tippView.layer.shadowColor = UIColor.black.cgColor
        tippView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tippView.layer.shadowOpacity = 1.0
        tippView.layer.shadowRadius = 8.0
        
        createBubbles()
        loadTipps()
    }
    
    private func createBubbles() {
        let viewWidth = Int(UIScreen.main.bounds.width)
        let viewHeight = Int(UIScreen.main.bounds.height)
        for _ in 0...5 {
            let bubbleWidth = 50 + Int(arc4random_uniform(100))
            let xPos = Int(arc4random_uniform(UInt32(viewWidth-bubbleWidth)))
            let yPos = Int(arc4random_uniform(UInt32(viewHeight)))
            let bubble = BubbleButton(frame: CGRect(x: xPos, y: yPos, width: bubbleWidth, height: bubbleWidth))
            bubble.addTarget(self, action: #selector(TippsController.pop(_:)), for: .touchDown)
            bubbles.append(bubble)
            self.bubbleView.insertSubview(bubble, at:0)
            bubble.animate()
        }
    }
    
    @objc func pop(_ bubble: BubbleButton) {
        UIView.transition(with: bubble, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseIn], animations: { bubble.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) }, completion: { _ in
            bubble.transform = CGAffineTransform(scaleX: 1, y: 1)
            bubble.layer.removeAllAnimations()
            self.showRandomTipp()
        } )
    }
    
    private func showRandomTipp() {
        let randomIndex = Int(arc4random_uniform(UInt32(tipps.count)))
        tippHeading.text = popupController.tipps[randomIndex].heading.uppercased()
        tippContent.text = popupController.tipps[randomIndex].content
        
        tippView.isHidden = false
        
        tippView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.transition(with: tippView, duration: 0.2, options: .transitionCrossDissolve, animations: { self.tippView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)}, completion: nil)
        
        view.bringSubview(toFront: tippView)
    }
    
    @IBAction func closeTipp() {
        tippView.isHidden = true
        view.sendSubview(toBack: tippView)
    }
    
    private func showPopup() {
        closeTipp()
        popupController.view.frame.origin.y = view.frame.height
        UIView.animate(withDuration:0.2, animations: {self.popupController.view.frame.origin.y = self.popupContainer.frame.origin.y},
                       completion: nil)
        popupContainer.isHidden = false
    }
    
    func closePopup() {
        popupContainer.isHidden = true
        chatBotIsActive = false
    }
    
    @objc private func keyboardChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardY = keyboardRect?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(truncating: animationCurveRawNSN!)),
                           animations: { self.view.frame.size.height = keyboardY},
                           completion: {_ in self.popupController.scrollToBottom()})
            popupController.scrollToBottom()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popupController = segue.destination as? TippsPopupController {
            self.popupController = popupController
            popupController.delegate = self
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !chatBotIsActive {
            showPopup()
            sendWelcomeRequest()
        }
    }
    
    func sendWelcomeRequest() {
        let welcomeRequest = ApiAI.shared().eventRequest()
        welcomeRequest?.event = AIEvent(name: "WELCOME")
        welcomeRequest?.setMappedCompletionBlockSuccess({ (welcomeRequest, response) in
            let response = response as! AIResponse
            self.chatBotIsActive = true
            if let textResponse = response.result.fulfillment.messages[0]["speech"] as? String{
                self.popupController.showResponse(response: textResponse )
            }
        }, failure: { (request, error) in
            print(error!)
            self.popupController.showResponse(response: "Verbindung zum Chatbot nicht möglich" )
        })
        ApiAI.shared().enqueue(welcomeRequest)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Display results while still typing?
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
        if let searchQuery = searchBar.text {
            if !searchQuery.isEmpty {
                if chatBotIsActive {
                    sendMessageToBot(text: searchQuery)
                } else {
                    self.popupController.showSearchResult(searchQuery: searchQuery)
                }
            }
        }
    }
    
    func sendMessageToBot(text: String) {
        self.popupController.showInput(input: text )
        self.searchField.text = ""
        
        let request = ApiAI.shared().textRequest()
        request?.query = text
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.messages[0]["speech"] as? String {
                self.popupController.showResponse(response: textResponse )
            }
        }, failure: { (request, error) in
            print(error!)
            self.popupController.showResponse(response: "Verbindung zum Chatbot nicht möglich")
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeTipp()
        let touch = touches.first
        let touchLocation = (touch?.location(in: self.bubbleView))!
        if popupContainer.isHidden {
            for bubble in bubbles {
                if bubble.layer.presentation()?.hitTest(touchLocation) != nil {
                    bubble.sendActions(for: .touchDown)
                }
            }
        }
        //super.touchesBegan(touches, with: event)
    }
    
    private func loadTipps() {
        let tippsListURL: URL = URL(fileURLWithPath:Bundle.main.path(forResource:"tippsList", ofType: "plist")!)
        do {
            let data = try Data(contentsOf: tippsListURL)
            let decoder = PropertyListDecoder()
            self.tipps = try decoder.decode([Message].self, from: data)
        } catch {
            print(error)
        }
        
    }
    
}
