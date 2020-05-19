//
//  MyLibraryController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class MyLibraryController: UIViewController, AddBookDelegate, UITableViewDelegate {
    var myBooks: [Book] = []
    @IBOutlet weak var myLibraryTableView: UITableView!
    
    
    override func viewDidLoad() {
        LocalStorageManager.shared.loadLibraryBooks(completion: {(books: [Book]) -> () in myBooks = books})
        myLibraryTableView.delegate = self
        myLibraryTableView.dataSource = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocalStorageManager.shared.getLibraryBooks(completion: {(books: [Book]) -> () in myBooks = books})
        print(myBooks)
        myLibraryTableView.reloadData()
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMyBookSegue", let addMyBookController = segue.destination as? AddBookController {
            addMyBookController.bookHandleDelegate = self
            addMyBookController.type = "library"
        }
        
        if segue.identifier == "myBookDetailSegue", let bookDetailController = segue.destination as? BookDetailController {
            bookDetailController.book = myBooks[myLibraryTableView.indexPathForSelectedRow?.row ?? 0]
            bookDetailController.type = "library"
        }
    }
    
    func addBook(book: Book) {
        myBooks.append(book)
        myLibraryTableView.reloadData()
        LocalStorageManager.shared.saveLibraryBooks(books: myBooks, completion: {() -> () in return})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
    
extension MyLibraryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myLibraryTableView.dequeueReusableCell(withIdentifier: "MyBookCell", for: indexPath) as UITableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let book = myBooks[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myBooks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            LocalStorageManager.shared.saveLibraryBooks(books: myBooks, completion: {() -> () in return})
        }
    }
}
