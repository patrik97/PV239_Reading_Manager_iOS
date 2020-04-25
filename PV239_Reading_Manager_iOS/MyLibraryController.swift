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

class MyLibraryController: UIViewController {
    var myBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyLibraryController: MyLibraryBookDelegate {
    func addBook(book: Book) {
        myBooks.append(book)
    }
}
