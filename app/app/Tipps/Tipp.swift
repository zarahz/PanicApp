//
//  Message.swift
//  app
//
//  Created by Paula Wikidal on 31.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation

struct Message: Decodable {
    
    var isResponse = true
    var heading: String
    var content: String
    
    init(heading:String, content:String) {
        self.heading = heading
        self.content = content
    }
    
}
