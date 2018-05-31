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
    
    let spacingBetweenRows:CGFloat = 10
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTipps()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
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
    
    
    func loadSampleTipps() {
        for i in 1...3 {
            let tipp = Tipp(heading: "Tipp \(i)", content: "dfsg gs dvfms fsgjzdfgsjdz svdfg fsdgfhs sf end\ntefthf tfefth ttae tafe fxgje jtejrshshtdj  trstrsrsjrs rs tes trs zrs zsrs z udtdzrsos tdsztisrs zrdrd")
            tipps.append(tipp)
        }
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        displayedTipps.removeAll()
        tableView.reloadData()
    }
    
    func loadSearchResult(searchQuery: String?) {
        displayedTipps.removeAll()
        if let search = searchQuery {
            for tip in tipps {
                if tip.content.contains(search)  {
                    displayedTipps.append(tip)
                }
            }
        }
        tableView.reloadData()
        
    }
    
    func loadRandomTipp() {
        displayedTipps.removeAll()
        let randomIndex = Int(arc4random_uniform(UInt32(tipps.count)))
        displayedTipps.append(tipps[randomIndex])
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
