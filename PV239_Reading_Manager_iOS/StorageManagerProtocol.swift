//
//  StorageManagerProtocol.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Lukáš Matta on 19/05/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol {
    func loadLibraryBooks(completion: ([Book]) -> ())
    func loadWishedBooks(completion: ([Book]) -> ())
    func updateWishedBook(book: Book, completion: () -> ())
    func updateLibraryBook(book: Book, completion: () -> ())
    func moveBookToLibrary(book: Book, completion: () -> ())
}
