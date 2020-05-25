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
    
    @IBAction func editPressed(_ sender: UIButton) {
        if (wishlistTableView.isEditing) {
            sender.setTitle("Edit", for: UIControl.State.normal)
            wishlistTableView.setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: UIControl.State.normal)
            wishlistTableView.setEditing(true, animated: true)
        }
    }
    
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
            bookDetailController.type = "wished"
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
        
        let imageUrl = book.smallImageUrl ?? "";
        if (imageUrl != "") {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data: data!)
        } else {
            cell.imageView?.image = UIImage(systemName: "book")
        }
        
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
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = wishedBooks[sourceIndexPath.row]
        wishedBooks.remove(at: sourceIndexPath.row)
        wishedBooks.insert(itemToMove, at: destinationIndexPath.row)
        LocalStorageManager.shared.saveWishedBooks(books: wishedBooks, completion: {() -> () in return})
    }
}
