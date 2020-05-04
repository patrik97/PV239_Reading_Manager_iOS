//
//  WishedBooksController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit


class WishedBooksController: UIViewController, AddBookDelegate {
    var wishedBooks: [Book] = []
    @IBOutlet weak var wishlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWishedBookSegue", let addMyBookController = segue.destination as? AddBookController {
            addMyBookController.bookHandleDelegate = self
            addMyBookController.type = "wishlist"
        }
    }
    
    func addBook(book: Book) {
        wishedBooks.append(book)
        wishlistTableView.reloadData()
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
}

extension WishedBooksController: UITableViewDelegate {
    
}
