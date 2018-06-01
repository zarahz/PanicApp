//
//  TippsPopupController.swift
//  app
//
//  Created by Paula Wikidal on 30.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TippsPopupController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tipps = [Tipp]()
    var displayedTipps = [Tipp]()
    var searchQuery: String?
    var delegate: TippsController?
    
    let spacingBetweenRows:CGFloat = 10
    
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
        let cellIdentifier = "TippTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TippTableViewCell else {
            fatalError("The dequeued cell is not an instance of TippTableViewCell.")
        }
        
        let tipp = displayedTipps[indexPath.section]
        cell.headingLabel.text = tipp.heading
        cell.contentLabel.text = tipp.content
        
        return cell
    }
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.closePopup()
        displayedTipps.removeAll()
        tableView.reloadData()
    }
    
    func showSearchResult(searchQuery: String?) {
        print("show search result")
        displayedTipps.removeAll()
        if let search = searchQuery {
            for tip in tipps {
                if tip.content.contains(search)  {
                    displayedTipps.append(tip)
                }
            }
        }
        print("results: \(displayedTipps.count)")
        tableView.reloadData()
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
