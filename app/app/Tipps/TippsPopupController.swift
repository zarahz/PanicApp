//
//  TippsPopupController.swift
//  app
//
//  Created by Paula Wikidal on 30.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit
import AVFoundation

class TippsPopupController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var tipps = [Message]()
    var displayedMessages = [Message]()
    var searchQuery: String?
    var tipsController: TippsController?
    
    let spacingBetweenRows:CGFloat = 8
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var audioOn = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        loadTipps()
    }
    
    
    // MARK: UITableViewDataSource
    
    // One row per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // One section per message
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.displayedMessages.count
    }
    
    // Spacing
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.spacingBetweenRows
    }
    
    // Transparent view between messages
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Display cells from message List
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = displayedMessages[indexPath.section]
        var cellId:String
        
        // Message is chat message
        if message.heading.isEmpty {
            if message.isResponse {
                cellId = "ResponseCell"
            } else {
                cellId = "InputCell"
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else {
                fatalError("The dequeued cell is not an instance of MessageTableViewCell.")
            }
            cell.messageLabel.text = message.content
            return cell
        }
        // Message is tip
        else {
            cellId = "TipCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TippTableViewCell else {
                fatalError("The dequeued cell is not an instance of TipTableViewCell.")
            }
            cell.headingLabel.text = message.heading
            cell.contentLabel.text = message.content
            
            return cell
        }
    }
    
    // Clear background
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: Change displayed messages
    
    // Tip
    func showSearchResult(searchQuery: String) {
        displayedMessages.removeAll()
        for tip in tipps {
            if tip.content.lowercased().contains(searchQuery.lowercased()) ||
                tip.heading.lowercased().contains(searchQuery.lowercased()) {
                displayedMessages.append(tip)
            }
        }
        tableView.reloadData()
    }
    
    // Answer message
    func showResponse(response: String) {
        let message = Message(content: response)
        displayedMessages.append(message)
        tableView.reloadData()
        scrollToBottom()
        if(audioOn) {
            let speechUtterance = AVSpeechUtterance(string: response)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
            speechSynthesizer.speak(speechUtterance)
        }
    }
    
    // User message
    func showInput(input: String) {
        var message = Message(content: input)
        message.isResponse = false
        displayedMessages.append(message)
        tableView.reloadData()
        scrollToBottom()
    }
    
    // MARK: User interaction handling
    
    // Close chat view
    @IBAction func close(_ sender: UIButton) {
        tipsController?.closePopup()
        displayedMessages.removeAll()
        tableView.reloadData()
    }
    
    // Turn audio on and off
    @IBAction func changeAudio(_ sender: UIButton) {
        audioOn = !audioOn
        sender.isSelected = !sender.isSelected
    }
    
    
    // MARK: View management
    
    // Scroll to newest message
    func scrollToBottom() {
        if tableView.numberOfSections > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections-1), at: .bottom , animated: false)
            tableView.layoutIfNeeded()
        }
    }
    
    
    // load tips from property list
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
}
