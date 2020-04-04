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
    private(set) var author: String
    private(set) var title: String
    private(set) var genre: String
    private(set) var notes = [BookNote]()
    
    init(id: Int, author: String, title: String, genre: String) {
        self.id = id
        self.author = author
        self.title = title
        self.genre = genre
    }
    
    func setId(id: Int) {
        self.id = id
    }
    
    func setAuthor(author: String) {
        self.author = author
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setGenre(genre: String) {
        self.genre = genre
    }
    
    static func getCurrentDate() -> DateComponents {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: currentDate)
    }
    
    func addNote(note: String) {
        notes.append(BookNote(note: note, added: Book.getCurrentDate()))
    }
}
