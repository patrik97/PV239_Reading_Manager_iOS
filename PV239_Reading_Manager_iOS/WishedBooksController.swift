//
//  WishedBooksController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

private let WISHLIST_BOOKS_KEY = "wished_books"

class WishedBooksController: UIViewController, AddBookDelegate, UITableViewDelegate {
    var wishedBooks: [Book] = []
    @IBOutlet weak var wishlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWishlistBooks()
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWishedBookSegue", let addMyBookController = segue.destination as? AddBookController {
            addMyBookController.bookHandleDelegate = self
            addMyBookController.type = "wishlist"
        }
        
        if segue.identifier == "wishedBookDetailSegue", let bookDetailController = segue.destination as? BookDetailController {
            bookDetailController.book = wishedBooks[wishlistTableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
    
    func addBook(book: Book) {
        wishedBooks.append(book)
        wishlistTableView.reloadData()
        persistWishlistBooks()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension WishedBooksController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishlistTableView.dequeueReusableCell(withIdentifier: "WishedBookCell", for: indexPath) as UITableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let book = wishedBooks[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             wishedBooks.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
             persistWishlistBooks()
        }
    }
}

extension WishedBooksController {
    private func persistWishlistBooks() {
        do {
            let booksAsJson = try JSONEncoder().encode(wishedBooks)
            UserDefaults.standard.set(booksAsJson, forKey: WISHLIST_BOOKS_KEY)
        } catch (let error) {
            print("Error when saving wishlist books: \(error)")
        }
    }
    
    private func loadWishlistBooks() {
        guard let jsonData = UserDefaults.standard.data(forKey: WISHLIST_BOOKS_KEY) else {
            return
        }
        
        do {
            wishedBooks = try JSONDecoder().decode([Book].self, from: jsonData)
        } catch (let error) {
            print("Error when loading wishlist books: \(error)")
        }
    }
}
