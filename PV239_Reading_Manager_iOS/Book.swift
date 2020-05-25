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
    let smallImageUrl: String?
    let imageUrl: String?
    
    init(id: Int, author: String, title: String, smallImageUrl: String?, imageUrl: String?) {
        self.id = id;
        self.author = author;
        self.title = title;
        self.smallImageUrl = smallImageUrl
        self.imageUrl = imageUrl
    }
    
    convenience init(id: Int, author: String, title: String) {
        self.init(id: id, author: author, title: title, smallImageUrl: nil, imageUrl: nil)
    }
    
    /*
     Add new note into notes
     */
    func addNote(note: String) {
        notes.append(BookNote(note: note, added: Date()))
    }
    
    func removeNote(index: Int) {
        notes.remove(at: index)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        if (lhs.id == rhs.id) {
            return true
        }
        return false
    }
}
