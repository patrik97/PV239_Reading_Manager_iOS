//
//  BookDetailController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.orientation.isLandscape {
            bookTitle.numberOfLines = 2
            bookAuthor.numberOfLines = 1
        }
        bookTitle.text = book?.title
        bookAuthor.text = book?.author
    }
}
