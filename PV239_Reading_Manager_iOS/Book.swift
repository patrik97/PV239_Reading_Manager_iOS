//
//  Book.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class Book: Codable, Equatable {
    let id: Int
    let author: String
    let title: String
    var notes = [BookNote]()
    var state = BookState.notOwned
    
    init(id: Int, author: String, title: String) {
        self.id = id;
        self.author = author;
        self.title = title;
    }

    /*
     Add new note into notes
     */
    func addNote(note: String) {
        notes.append(BookNote(note: note, added: Date()))
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        if (lhs.id == rhs.id) {
            return true
        }
        return false
    }
}
