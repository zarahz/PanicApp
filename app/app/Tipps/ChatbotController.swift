//
//  ChatbotController.swift
//  app
//
//  Created by Paula Wikidal on 22.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import ApiAI
import CallKit
import Contacts
import Speech

class ChatbotController {
    
    var isActive = false
    var popupController: TippsPopupController!
    var phoneNr: String?
    
    func sendEventRequest(eventName: String) {
        let request = ApiAI.shared().eventRequest()
        request?.event = AIEvent(name: eventName)
        handleCompletion(request: request)
        ApiAI.shared().enqueue(request)
    }
    
    func handleCompletion(request: AIRequest?) {
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            self.isActive = true
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.messages[0]["speech"] as? String {
                if !self.handleAction(response: response) {
                    self.popupController.showResponse(response: textResponse )
                }
            }
        }, failure: { (request, error) in
            self.popupController.showResponse(response: "Verbindung zum Chatbot nicht möglich")
        })
    }
    
    func sendMessageToBot(text: String) {
        self.popupController.showInput(input: text )
        
        let request = ApiAI.shared().textRequest()
        request?.query = text
        handleCompletion(request: request)
        ApiAI.shared().enqueue(request)
    }
    
    private func handleAction(response: AIResponse) -> Bool {
        let action = response.result.action
        switch(action) {
        case "call":
            guard var name = (response.result.parameters["given-name"] as? AIResponseParameter)?.stringValue else {
                fatalError("Name parameter is missing")
            }
            if let lastName = (response.result.parameters["last-name"] as? AIResponseParameter)?.stringValue {
                if !name.isEmpty {
                name = name+" "+lastName
                } else {
                    name = lastName
                }
            }
            if name.isEmpty {
                return false
            }
            if getContact(name: name) {
                self.popupController.showResponse(response: "Soll ich \(name) für dich anrufen?")
            } else {
                self.popupController.showResponse(response: "Ich habe in deinen Kontakten niemanden mit dem Namen \(name) gefunden.")
            }
            return true
        case "callConfirmed":
            callNumber()
            return true
        case "callSomeone":
            let request = ApiAI.shared().textRequest()
            request?.query = "Telefonat"
            handleCompletion(request: request)
            ApiAI.shared().enqueue(request)
            return true
        case "exampleQuestions":
            sendEventRequest(eventName: "EXAMPLE_QUESTIONS")
            return true
        default: return false
        }
    }
    
    func callNumber() {
        if let nr = phoneNr {
            guard let number = URL(string: "tel://" + nr) else { return }
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(number)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(number)
                } else {
                    UIApplication.shared.openURL(number)
                }
                phoneNr = nil
            }
        }
    }
    
    func getContact(name: String) -> Bool {
        do {
            let store = CNContactStore()
            let contacts = try store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor])
            
            guard let contact = contacts.first else {
                //no contact with this name found
                return false
            }
            
            guard let nr = contact.phoneNumbers.first else {
                //contact doesn't have a phone number
                return false
            }
            
            let number = nr.value.stringValue.filter({c in c >= "0" && c <= "9"})
            phoneNr = number
            return true
            
        } catch {
            return false
        }
        
    }
    
    
}

@available(iOS 10.0, *)
class SpeechListener {
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "de-DE"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var detectedText: String?
    let chatbotController: ChatbotController
    let button: UIButton
    
    init(chatbotController: ChatbotController, button: UIButton) {
        self.chatbotController = chatbotController
        self.button = button
    }
    
    func transcribeSpeech() {
        button.isSelected = true
        detectedText = nil
        let node = audioEngine.inputNode
        let format = node.inputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: format, block: {buffer, _ in self.request.append(buffer)})
        audioEngine.prepare()
        do {
            try audioEngine.start() }
        catch {
            print(error)
        }
        var timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.stopRecording()
            timer.invalidate()
        })
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.detectedText = result.bestTranscription.formattedString
                timer.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                    if let text = self.detectedText {
                        timer.invalidate()
                        self.chatbotController.sendMessageToBot(text: text)
                        self.stopRecording()
                    }})
            } else if let error = error {
                print(error)
                self.stopRecording() 
                timer.invalidate()
            }})
    }
    
    func stopRecording() { 
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        detectedText = nil
        button.isSelected = false
    }
}
