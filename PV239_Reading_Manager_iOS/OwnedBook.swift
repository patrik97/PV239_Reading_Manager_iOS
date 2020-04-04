//
//  OwnedBook.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class OwnedBook: Book {
    private(set) var state: BookState
    private(set) var added: DateComponents
    
    override init() {
        state = BookState.Unread
        added = DateComponents()
        super.init()
    }
}
