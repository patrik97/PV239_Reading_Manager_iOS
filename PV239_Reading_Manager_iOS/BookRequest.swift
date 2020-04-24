//
//  BookRequest.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Lukáš Matta on 23/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

struct BookRequest {
    let resourceUrl: URL
    let APIKey = "XUN7Uwdku5cOS45aNGw"
    
    init(query: String) {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let resourceString = "https://www.goodreads.com/search/index.xml?key=\(APIKey)&q=\(escapedQuery ?? "")"
        
        self.resourceUrl = URL(string: resourceString)!
    }
}
