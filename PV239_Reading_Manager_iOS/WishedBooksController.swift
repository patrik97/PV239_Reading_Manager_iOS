//
//  WishedBooksController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

protocol WishedBooksDelegate: class {
    func addBook(book: Book)
}

class WishedBooksController: UIViewController {
    var wishedBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WishedBooksController: WishedBooksDelegate {
    func addBook(book: Book) {
        wishedBooks.append(book)
    }
}
