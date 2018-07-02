//
//  Message.swift
//  app
//
//  Created by Paula Wikidal on 31.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation

struct Message: Decodable {
    
    // MARK: Properties
    var isResponse: Bool
    var heading: String
    var content: String
    
    init(content:String) {
        self.heading = ""
        self.content = content
        self.isResponse = true
    }
    
    init(heading:String, content:String, isResponse:Bool) {
        self.heading = heading
        self.content = content
        self.isResponse = isResponse
    }
    
}
