//
//  LocalStorageManager.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Lukáš Matta on 19/05/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

private let LIBRARY_BOOKS_KEY = "library_books"
private let WISHLIST_BOOKS_KEY = "wished_books"


class LocalStorageManager: StorageManagerProtocol {
    static let shared = LocalStorageManager();
    
    private var libraryBooks: [Book] = [];
    private var wishedBooks: [Book] = [];
    
    private init() { }
    
    func getLibraryBooks(completion: ([Book]) -> ()) {
        print(libraryBooks)
        completion(libraryBooks)
    }
    
    func getWishedBooks(completion: ([Book]) -> ()) {
        completion(wishedBooks)
    }
    
    func loadAllBooks(completion: ([Book], [Book]) -> ()) {
        loadLibraryBooks(completion: {(libBooks) -> () in
            loadWishedBooks { (wishBooks) -> () in
                completion(libBooks, wishBooks)
            }
        })
    }
    
    func loadLibraryBooks(completion: ([Book]) -> ()) {
        guard let jsonData = UserDefaults.standard.data(forKey: LIBRARY_BOOKS_KEY) else {
           return
       }
       
       do {
           libraryBooks = try JSONDecoder().decode([Book].self, from: jsonData)
           completion(libraryBooks)
       } catch (let error) {
           print("Error when loading library books: \(error)")
       }
    }
    
    // Code repetition with previous function, TODO: Consider refactoring to one function
    func loadWishedBooks(completion: ([Book]) -> ()) {
        guard let jsonData = UserDefaults.standard.data(forKey: WISHLIST_BOOKS_KEY) else {
           return
        }
        
        do {
            wishedBooks = try JSONDecoder().decode([Book].self, from: jsonData)
            completion(wishedBooks)
        } catch (let error) {
            print("Error when loading wished books: \(error)")
        }
    }
    
    func saveLibraryBooks(books: [Book], completion: () -> ()) {
        do {
            let booksAsJson = try JSONEncoder().encode(books)
            UserDefaults.standard.set(booksAsJson, forKey: LIBRARY_BOOKS_KEY)
            libraryBooks = books
            completion()
        } catch (let error) {
            print("Error when saving library books: \(error)")
        }
    }
    
    // Code repetition with previous function, TODO: Consider refactoring to one function
    func saveWishedBooks(books: [Book], completion: () -> ()) {
        do {
            let booksAsJson = try JSONEncoder().encode(books)
            UserDefaults.standard.set(booksAsJson, forKey: WISHLIST_BOOKS_KEY)
            wishedBooks = books
            completion()
        } catch (let error) {
            print("Error when saving wished books: \(error)")
        }
    }
    
    func updateWishedBook(book: Book, completion: () -> ()) {
         if let index = wishedBooks.firstIndex(of: book) {
            wishedBooks[index] = book;
            saveWishedBooks(books: wishedBooks, completion: {() -> () in return})
            completion()
         } else {
            print("Invalid book");
            return
         }
    }
    
    func updateLibraryBook(book: Book, completion: () -> ()) {
        if let index = libraryBooks.firstIndex(of: book) {
            libraryBooks[index] = book;
            print(libraryBooks[index].notes)
            saveLibraryBooks(books: libraryBooks, completion: {() -> () in return})
            completion()
        } else {
           print("Invalid book");
           return
        }
    }
    
    func moveBookToLibrary(book: Book, completion: () -> ()) {
        if let index = wishedBooks.firstIndex(of: book) {
            wishedBooks.remove(at: index)
            book.state = BookState.unread
            libraryBooks.append(book)
            saveLibraryBooks(books: libraryBooks, completion: {() -> () in return})
            saveWishedBooks(books: wishedBooks, completion: {() -> () in return})
            completion()
        } else {
            print("Invalid book");
            return
        }
    }
    
    
}
