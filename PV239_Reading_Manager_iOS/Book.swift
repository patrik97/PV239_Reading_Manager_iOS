//
//  Book.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class Book {
    private(set) var id: Int
    private(set) var title: String
    private(set) var author: String
    private(set) var genre: String
    
    init() {
        id = -1;
        title = ""
        author = ""
        genre = ""
    }
}
