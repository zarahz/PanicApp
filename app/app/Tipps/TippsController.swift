//
//  TippsController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var bubbles = [BubbleButton]()
    var tipps = [Message]()
    var popupController: TippsPopupController!
    let chatbotController = ChatbotController()
    
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var tippView: UIView!
    @IBOutlet weak var tippHeading: UILabel!
    @IBOutlet weak var tippContent: UILabel!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var popupContainer: UIView!

    
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
       
        searchField.delegate = self
        
        // Layout
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        /* tippView.layer.shadowColor = UIColor.black.cgColor
        tippView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tippView.layer.shadowOpacity = 1.0
        tippView.layer.shadowRadius = 8.0 */
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        searchField.leftView = paddingView
        searchField.leftViewMode = .always
        
        UIView.animate(withDuration: 2.0, delay: 5.0, options: .curveEaseInOut, animations: {self.explanationLabel.alpha = 0}, completion: nil)
        
        // Handle change of keyboard size
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Hide keyboard after tap on view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        createBubbles()
        loadTipps()
    }
    
    // MARK: Setup functions
    
    // Create and animate bubble buttons
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
    
    // Load tips from property list
    private func loadTipps() {
        let tippsListURL: URL = URL(fileURLWithPath:Bundle.main.path(forResource:"tippsList", ofType: "plist")!)
        do {
            let data = try Data(contentsOf: tippsListURL)
            let decoder = PropertyListDecoder()
            self.tipps = try decoder.decode([Message].self, from: data)
        } catch {
            fatalError("Tips couldn't be loaded.")
        }
    }
    
    // Communication with popupController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popupController = segue.destination as? TippsPopupController {
            self.popupController = popupController
            chatbotController.popupController = popupController
            popupController.tipsController = self
        }
    }
    
    
    // MARK: User interaction handling
    
    // Pop bubble and show tip
    @objc func pop(_ bubble: BubbleButton) {
        UIView.transition(with: bubble, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseIn], animations: { bubble.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) }, completion: { _ in
            bubble.transform = CGAffineTransform(scaleX: 1, y: 1)
            bubble.layer.removeAllAnimations()
            bubble.animate()
            self.showRandomTipp()
        } )
    }
    
    // Open chatbot view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !chatbotController.isActive {
            showPopup()
            chatbotController.sendEventRequest(eventName: "WELCOME")
        }
    }
    
    // Activate voice rcognition
    @IBAction func startVoiceRecognition(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            if !chatbotController.isActive {
                showPopup()
                chatbotController.sendEventRequest(eventName: "WELCOME")
            }
            SpeechListener(chatbotController: self.chatbotController, button: sender).transcribeSpeech()
            }
    }
    
    // Send textfield input to chatbot
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchQuery = searchField.text {
            if !searchQuery.isEmpty {
                if chatbotController.isActive {
                    chatbotController.sendMessageToBot(text: searchQuery)
                    textField.text = ""
                } else {
                    self.popupController.showSearchResult(searchQuery: searchQuery)
                }
            }
        }
        return true
    }
    
    // Recognize bubble touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = (touch?.location(in: self.bubbleView))!
        if popupContainer.isHidden {
            if tippView.isHidden {
                for bubble in bubbles {
                    if bubble.layer.presentation()?.hitTest(touchLocation) != nil {
                        bubble.sendActions(for: .touchDown)
                        break
                    }
                }
            } else {
                closeTipp()
            }
        }
    }
    
    
    // MARK: View management
    
    // Hide keyboard
    @objc func hideKeyboard() {
        searchField.resignFirstResponder()
    }
    
    // Adjust chat view depending on keyboard size
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
            self.view.layoutIfNeeded()
        }
    }
    
    // Load and show tip
    private func showRandomTipp() {
        let randomIndex = Int(arc4random_uniform(UInt32(tipps.count)))
        tippHeading.text = popupController.tipps[randomIndex].heading.uppercased()
        tippContent.text = popupController.tipps[randomIndex].content
        
        tippView.isHidden = false
        
        tippView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.transition(with: tippView, duration: 0.2, options: .transitionCrossDissolve, animations: { self.tippView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)}, completion: nil)
        
        view.bringSubview(toFront: tippView)
    }
    
    // Hide tip view
    @IBAction func closeTipp() {
        tippView.isHidden = true
        view.sendSubview(toBack: tippView)
    }
    
    // Show chatbot view
    private func showPopup() {
        closeTipp()
        popupController.view.frame.origin.y = view.frame.height
        UIView.animate(withDuration:0.2, animations: {self.popupController.view.frame.origin.y = self.popupContainer.frame.origin.y},
                       completion: nil)
        popupContainer.isHidden = false
    }
    
    // Hide chatbot view
    func closePopup() {
        popupContainer.isHidden = true
        chatbotController.isActive = false
        searchField.text = ""
        searchField.resignFirstResponder()
    }
    
}
