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
    @IBOutlet weak var bookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteCollectionView.dataSource = self
        noteCollectionView.delegate = self
        let size = UIScreen.main.bounds.width - 50
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: size, height: 100)
        noteCollectionView.setCollectionViewLayout(layout, animated: true)
        bookTitle.text = book?.title
        bookAuthor.text = book?.author
        let imageUrl = book?.imageUrl ?? "";
        if (imageUrl != "") {
            let url = URL(string: imageUrl)
            let data = try? Data(contentsOf: url!)
            bookImage.image = UIImage(data: data!)
        } else {
            bookImage.image = UIImage(systemName: "book")
       }
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
        deleteButton.isHidden = count == 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookNoteCell", for: indexPath) as? NoteCell else {
            return UICollectionViewCell()
        }
        
        cell.noteLabel.text = book?.notes[indexPath.row].note
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. MM. yy"
        formatter.string(from: book?.notes[indexPath.row].added ?? Date())
        cell.backgroundColor = lightGray
        cell.isSelectedNow = false
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setCollectionViewLayout()
        noteCollectionView.reloadData()
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
    
    private func setCollectionViewLayout() {
        var size = UIScreen.main.bounds.width - 50
        if UIDevice.current.orientation.isLandscape {
            size = (UIScreen.main.bounds.height / 2 ) - 30
            if UIDevice.current.hasNotch {
                size -= 50
            }
        } else {
            size = UIScreen.main.bounds.height - 50
        }
        let cellSize = CGSize(width: size, height: 100)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        noteCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

class NoteCell : UICollectionViewCell {
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var isSelectedNow = false
}

// source: https://medium.com/@cafielo/how-to-detect-notch-screen-in-swift-56271827625d
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
