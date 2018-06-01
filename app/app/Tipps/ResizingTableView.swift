//
//  ResizingTableView.swift
//  app
//
//  Created by Paula Wikidal on 31.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class ResizingTableView: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
        print("sections: \(numberOfSections)")
    }
    
    override var intrinsicContentSize: CGSize {
        
        let height = min(contentSize.height, maxHeight)
        print("height: \(height)")
        return CGSize(width: contentSize.width, height: height)
    }

}
