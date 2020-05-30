//
//  AddBookController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit
import Alamofire

protocol AddBookDelegate: class {
    func addBook(book: Book)
}

class AddBookController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var books: [Book] = []
    var elementName: String = String()
    var bookTitle = String()
    var bookAuthor = String()
    var bookImageUrl = String()
    var bookSmallImageUrl = String()
    var bookId = Int()
    var type = String()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var booksTable: UITableView!
    weak var bookHandleDelegate: AddBookDelegate?
    
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
                        self.books = []
                        if parser.parse() {
                            //print(self.books)
                            self.booksTable.reloadData()
                        }
            }
        } else {
            books = []
            self.booksTable.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let alert = UIAlertController(title: "Add this book to \(self.type)?", message: book.author + "\n" + book.title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in self.addToMyLibrary(indexPath: indexPath) }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func addToMyLibrary(indexPath: IndexPath) {
        bookHandleDelegate?.addBook(book: books[indexPath.row])
        books.remove(at: indexPath.row)
        self.booksTable.reloadData()
    }
}

extension AddBookController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchText)
        perform(#selector(self.reload(_:)), with: searchText, afterDelay: 0.5)
    }

    func
        searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchBooks(query: searchBar.text ?? "")
    }
    
    @objc func reload(_ searchText: String) {
        fetchBooks(query: searchText)
    }
}

extension AddBookController: XMLParserDelegate {
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "best_book" {
            bookTitle = String()
            bookAuthor = String()
            bookImageUrl = String()
            bookSmallImageUrl = String()
        }

        self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "best_book" {
            let book = Book(id: bookId, author: bookAuthor, title: bookTitle, smallImageUrl: bookSmallImageUrl, imageUrl: bookImageUrl)
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
            } else if self.elementName == "image_url" {
                bookImageUrl += data
            } else if self.elementName == "small_image_url" {
                bookSmallImageUrl += data
            }
        }
    }
}




