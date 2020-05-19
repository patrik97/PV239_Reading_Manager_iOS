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
    @IBOutlet var cellGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var book: Book?
    // TODO: Replace with type struct -> "library" or "wished"
    var type: String = ""
    let lightGray = UIColor.systemGray5
    let darkGray = UIColor.systemGray2
    
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
            addNoteController.type = type
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = book?.notes.count ?? 0
        if count == 0 {
            deleteButton.isHidden = true
        } else {
            deleteButton.isHidden = false
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookNoteCell", for: indexPath) as? NoteCell else {
            return UICollectionViewCell()
        }
        
        cell.noteLabel.text = book?.notes[indexPath.row].note
        cell.backgroundColor = lightGray
        cell.isSelectedNow = false
        return cell
    }
    
    @IBAction func deleteCellsButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete", message: "Do you really want to delete selected notes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in self.deleteCells() }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func deleteCells() {
        let size = noteCollectionView.numberOfItems(inSection: 0)
        
        for i in 0 ... size-1 {
            let indexPath = IndexPath(row: size-1-i, section: 0)
            guard let cell = noteCollectionView.cellForItem(at: indexPath) as? NoteCell else {
                continue
            }
            if cell.isSelectedNow {
                book?.removeNote(index: size-1-i)
            }
        }
        
        if (type == "library") {
            LocalStorageManager.shared.updateLibraryBook(book: book!, completion: {() -> () in return})
        }
        if (type == "wished") {
            LocalStorageManager.shared.updateWishedBook(book: book!, completion: {() -> () in return})
        }
        noteCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NoteCell else {
            return
        }
        if cell.isSelectedNow {
            cell.isSelectedNow = false
            cell.backgroundColor = lightGray
        } else {
            cell.isSelectedNow = true
            cell.backgroundColor = darkGray
        }
    }
}

class NoteCell : UICollectionViewCell {
    @IBOutlet weak var noteLabel: UILabel!
    var isSelectedNow = false
}
