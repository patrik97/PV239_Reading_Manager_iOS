//
//  WishedBook.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class WishedBook: Book {
    private(set) var added: DateComponents
    
    override init(id: Int, author: String, title: String, genre: String) {
        added = Book.getCurrentDate()
        super.init(id: id, author: author, title: title, genre: genre)
    }
}
