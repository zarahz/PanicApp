//
//  TippsPopupController.swift
//  app
//
//  Created by Paula Wikidal on 30.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsPopupController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tipps = [Message]()
    var displayedTipps = [Message]()
    var searchQuery: String?
    var tipsController: TippsController?
    
    let spacingBetweenRows:CGFloat = 8
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        
        loadTipps()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func close(_ sender: UIButton) {
        tipsController?.closePopup()
        displayedTipps.removeAll()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.displayedTipps.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.spacingBetweenRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = displayedTipps[indexPath.section]
        var cellId:String
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func showSearchResult(searchQuery: String) {
        displayedTipps.removeAll()
        for tip in tipps {
            if tip.content.lowercased().contains(searchQuery.lowercased()) ||
                tip.heading.lowercased().contains(searchQuery.lowercased()) {
                displayedTipps.append(tip)
            }
        }
        tableView.reloadData()
    }
    
    func showResponse(response: String) {
        let message = Message(content: response)
        displayedTipps.append(message)
        tableView.reloadData()
        scrollToBottom()
    }
    
    func showInput(input: String) {
        var message = Message(content: input)
        message.isResponse = false
        displayedTipps.append(message)
        tableView.reloadData()
        scrollToBottom()
    }
    
    func scrollToBottom() {
        if tableView.numberOfSections > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections-1), at: .top , animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tipsController?.searchField.resignFirstResponder()
        print("popup touched")
        super.touchesBegan(touches, with: event)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tipsController?.searchField.resignFirstResponder()
        return indexPath
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
