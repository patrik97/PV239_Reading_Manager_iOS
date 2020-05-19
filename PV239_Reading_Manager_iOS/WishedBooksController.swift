//
//  WishedBooksController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class WishedBooksController: UIViewController, AddBookDelegate, UITableViewDelegate {
    var wishedBooks: [Book] = []
    @IBOutlet weak var wishlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalStorageManager.shared.loadWishedBooks(completion: {(books: [Book]) -> () in wishedBooks = books})
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocalStorageManager.shared.loadWishedBooks(completion: {(books: [Book]) -> () in wishedBooks = books})
        wishlistTableView.reloadData()
        super.viewDidAppear(animated);
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
        LocalStorageManager.shared.saveWishedBooks(books: wishedBooks, completion: {() -> () in return})
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
    
    
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.wishedBooks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            LocalStorageManager.shared.saveWishedBooks(books: self.wishedBooks, completion: {() -> () in return})
        }
        delete.backgroundColor = UIColor.red

        let complete = UITableViewRowAction(style: .default, title: "Move to Library") { (action, indexPath) in
            LocalStorageManager.shared.moveBookToLibrary(book: self.wishedBooks[indexPath.row], completion: {() -> () in
                    self.wishedBooks.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
        }
        complete.backgroundColor = UIColor.blue

        return [delete, complete]
    }
}
