//
//  NavigationController.swift
//  app
//
//  Created by Paula Wikidal on 29.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes background transparent
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        
        let image = UIImage(named: "Navbar_bg.png")
        navigationItem.titleView = UIImageView(image: image)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
    }
    
}

//extension to show mode icon in navigation in every screen
extension UIViewController {
    func setupNavigationBar() {
        /* back button without title
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //set titile
        self.navigationItem.title = title
        
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "busket"), style: .plain, target: nil, action: nil)
        
        //show the Edit button item
        self.navigationItem.rightBarButtonItem = rightButton*/
        
        //navigation mode icon
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "bubble"), for: UIControlState.normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true; button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
}

