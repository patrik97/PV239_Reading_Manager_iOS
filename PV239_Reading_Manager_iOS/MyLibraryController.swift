//
//  MyLibraryController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class MyLibraryController: UIViewController, AddBookDelegate {
    var myBooks: [Book] = []
    @IBOutlet weak var myLibraryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLibraryTableView.delegate = self
        myLibraryTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMyBookSegue", let addMyBookController = segue.destination as? AddBookController {
            addMyBookController.bookHandleDelegate = self
            addMyBookController.type = "library"
        }
    }
    
    func addBook(book: Book) {
        myBooks.append(book)
        myLibraryTableView.reloadData()
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
}

extension MyLibraryController: UITableViewDelegate {
    
}
