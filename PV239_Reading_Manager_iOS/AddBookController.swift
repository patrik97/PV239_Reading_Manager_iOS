//
//  AddBookController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit
import Alamofire

class AddBookController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var books: [Book] = []
    var elementName: String = String()
    var bookTitle = String()
    var bookAuthor = String()
    var bookId = Int()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var booksTable: UITableView!
    weak var myLibraryBookDelegate: MyLibraryBookDelegate?
    weak var wishedBookDelegate: WishedBookDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        booksTable.delegate = self
        booksTable.dataSource = self
    }
    
    private func fetchBooks(query: String) {
        if (query != "") {
            AF.request(BookRequest(query: query).resourceUrl).responseData{
                response in
                    guard let data = response.data else {
                        print("Unknown error")
                        return
                    }
                    
                    let parser = XMLParser(data: data)
                        parser.delegate = self
                        if parser.parse() {
                            print(self.books)
                            self.booksTable.reloadData()
                        }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = booksTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let alert = UIAlertController(title: "Do you wish to add this book to yours?", message: book.author + "\n" + book.title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes to Library", style: .default, handler: { action in self.addToMyLibrary(indexPath: indexPath) }))
        alert.addAction(UIAlertAction(title: "Yes to Wishlist", style: .default, handler: { action in self.addToWishedBooks(indexPath: indexPath)} ))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func addToMyLibrary(indexPath: IndexPath) {
        myLibraryBookDelegate?.addBook(book: books[indexPath.row])
        books.remove(at: indexPath.row)
        self.booksTable.reloadData()
    }
    
    private func addToWishedBooks(indexPath: IndexPath) {
        wishedBookDelegate?.addBook(book: books[indexPath.row])
        books.remove(at: indexPath.row)
        self.booksTable.reloadData()
    }
}

extension AddBookController: UISearchBarDelegate {
    func
        searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        books = []
        fetchBooks(query: searchBar.text ?? "")
    }
}

extension AddBookController: XMLParserDelegate {
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "best_book" {
            bookTitle = String()
            bookAuthor = String()
        }

        self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "best_book" {
            let book = Book(id: bookId, author: bookAuthor, title: bookTitle)
            books.append(book)
        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "id" {
                bookId = Int(data) ?? 0
            } else if self.elementName == "title" {
                bookTitle += data
            } else if self.elementName == "name" {
                bookAuthor += data
            }
        }
    }
}




