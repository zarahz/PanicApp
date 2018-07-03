//
//  ViewControllerExtension.swift
//  app
//
//  Created by Zarah Zahreddin on 02.07.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation

//extension to show mode icon in navigation in every screen
extension UIViewController {
    func setupNavigationBar() {
        //navigation mode icon
        let button = UIButton.init(type: .custom)
        switch UserDefaults.standard.integer(forKey: "mode") {
        //on Road mode
        case 0:
            button.setImage(UIImage(named: "jellyfish"), for: UIControlState.normal)
        //at home mode
        case 1:
            button.setImage(UIImage(named: "bubble"), for: UIControlState.normal)
        //GPS mode
        case -1:
            if(Location.shared.outOfHomeArea){
                button.setImage(UIImage(named: "jellyfish"), for: UIControlState.normal)
            }else{
                button.setImage(UIImage(named: "bubble"), for: UIControlState.normal)
            }
        default:
            button.setImage(UIImage(named: "jellyfish"), for: UIControlState.normal)
        }
        
        
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func getMode() -> Int{
        switch UserDefaults.standard.integer(forKey: "mode") {
        //on Road mode
        case 0:
            return 0
        //at home mode
        case 1:
            return 1
        //GPS mode
        case -1:
            if(Location.shared.outOfHomeArea){
                return 0
            }else{
                return 1
            }
        default:
            return 0
        }
    }
}

