//
//  MyLibraryController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit


protocol MyLibraryBookDelegate: class {
    func addBook(book: Book)
}

class MyLibraryController: UIViewController, MyLibraryBookDelegate {
    var myBooks: [Book] = []
    @IBOutlet weak var myBooksCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myBooksCollection.dataSource = self
        myBooksCollection.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMyBookSegue", let addMyBookController = segue.destination as? AddBookController {
            addMyBookController.myLibraryBookDelegate = self
        }
    }
    
    func addBook(book: Book) {
        myBooks.append(book)
        myBooksCollection.reloadData()
    }
}

extension MyLibraryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myBookCell", for: indexPath) as? MyBookCell else {
            return UICollectionViewCell()
        }
        let book = myBooks[indexPath.item]
        cell.authorLabel.text = book.author
        cell.titleLabel.text = book.title
        return cell
    }
}

extension MyLibraryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

class MyBookCell: UICollectionViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
