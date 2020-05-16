//
//  BookDetailController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var noteCollectionView: UICollectionView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteCollectionView.dataSource = self
        noteCollectionView.delegate = self
        bookTitle.text = book?.title
        bookAuthor.text = book?.author
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBookNoteSegue", let addNoteController = segue.destination as? AddNoteController {
            addNoteController.book = book
            addNoteController.noteCollectionView = noteCollectionView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return book?.notes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookNoteCell", for: indexPath) as? NoteCell else {
            return UICollectionViewCell()
        }
        
        cell.noteLabel.text = book?.notes[indexPath.row].note
        return cell
    }
}

class NoteCell : UICollectionViewCell {
    @IBOutlet weak var noteLabel: UILabel!
}
