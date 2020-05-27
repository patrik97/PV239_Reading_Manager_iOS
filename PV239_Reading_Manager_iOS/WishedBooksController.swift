//
//  WishedBooksController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

protocol SetVisibleBooksDelegate: class {
    func setVisibleBooks(searchText: String)
}

class WishedBooksController: UIViewController, AddBookDelegate, UITableViewDelegate, SetVisibleBooksDelegate {
    var wishedBooks: [Book] = []
    var visibleBooks: [Book] = []
    @IBOutlet weak var wishlistSearchBar: UISearchBar!
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
        visibleBooks = wishedBooks
        wishlistSearchBar.delegate = self
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocalStorageManager.shared.loadWishedBooks(completion: {(books: [Book]) -> () in wishedBooks = books})
        setVisibleBooks(searchText: wishlistSearchBar.text ?? "")
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
        book.state = BookState.notOwned
        wishedBooks.append(book)
        setVisibleBooks(searchText: wishlistSearchBar.text ?? "")
        wishlistTableView.reloadData()
        LocalStorageManager.shared.saveWishedBooks(books: wishedBooks, completion: {() -> () in return})
    }
    
    func setVisibleBooks(searchText: String) {
        if (searchText == "") {
            visibleBooks = wishedBooks
        } else {
            visibleBooks = wishedBooks.filter{$0.author.contains(searchText) || $0.title.contains(searchText)}
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension WishedBooksController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishlistTableView.dequeueReusableCell(withIdentifier: "WishedBookCell", for: indexPath) as UITableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let book = visibleBooks[indexPath.row]
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
            let itemToDelete = self.visibleBooks[indexPath.row]
            self.visibleBooks.remove(at: indexPath.row)
            self.wishedBooks.removeAll(where: {$0.id == itemToDelete.id})
            tableView.deleteRows(at: [indexPath], with: .fade)
            LocalStorageManager.shared.saveWishedBooks(books: self.wishedBooks, completion: {() -> () in return})
        }
        delete.backgroundColor = UIColor.red

        let complete = UITableViewRowAction(style: .default, title: "Move to Library") { (action, indexPath) in
            LocalStorageManager.shared.moveBookToLibrary(book: self.visibleBooks[indexPath.row], completion: {() -> () in
                    let itemToDelete = self.visibleBooks[indexPath.row]
                    self.visibleBooks.remove(at: indexPath.row)
                    self.wishedBooks.removeAll(where: {$0.id == itemToDelete.id})
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
        let itemToMove = visibleBooks[sourceIndexPath.row]
        let originalDestinationItem = visibleBooks[destinationIndexPath.row]
        let moveItemIndex = wishedBooks.firstIndex(of: itemToMove) ?? 0
        let destinationItemIndex = wishedBooks.firstIndex(of: originalDestinationItem) ?? wishedBooks.count-1
        visibleBooks.remove(at: sourceIndexPath.row)
        visibleBooks.insert(itemToMove, at: destinationIndexPath.row)
        wishedBooks.remove(at: moveItemIndex)
        wishedBooks.insert(itemToMove, at: destinationItemIndex)
        LocalStorageManager.shared.saveWishedBooks(books: wishedBooks, completion: {() -> () in return})
    }
}

extension WishedBooksController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setVisibleBooks(searchText: searchText)
        wishlistTableView.reloadData()
    }
}

