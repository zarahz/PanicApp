//
//  MessageTableViewCell.swift
//  app
//
//  Created by Paula Wikidal on 08.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
