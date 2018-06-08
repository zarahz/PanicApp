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
    var delegate: TippsController?
    
    let spacingBetweenRows:CGFloat = 15
    
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
        
        var cellId:String {
            if !message.isResponse {return "InputCell"}
            else if message.heading.isEmpty {return "ResponseCell"}
            else {return "TipCell"}
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TippTableViewCell else {
            fatalError("The dequeued cell is not an instance of TippTableViewCell.")
        }
        cell.headingLabel.text = message.heading
        cell.contentLabel.text = message.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.closePopup()
        displayedTipps.removeAll()
        tableView.reloadData()
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
        tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections-1), at: .top , animated: true)
    }
    
    func showInput(input: String) {
        var message = Message(content: input)
        message.isResponse = false
        displayedTipps.append(message)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections-1), at: .bottom , animated: true)
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
