//
//  BookDetailController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class BookDetailController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let transparentView = UIView();
    let tableView = UITableView();
    let bookStates = ["Unread", "Reading", "Readed"]
    @IBOutlet weak var bookStateLabel: UILabel!
    weak var setVisibleBooksDelegate: SetVisibleBooksDelegate?
    
    @IBAction func addToLibrary(_ sender: UIButton) {
        if (type == "library") {
            addTransparentView(frames: moveToLibraryButton.frame)
        } else {
            LocalStorageManager.shared.moveBookToLibrary(book: self.book!, completion: {() -> () in
                self.navigationController?.popViewController(animated: true)
                setVisibleBooksDelegate?.setVisibleBooks(searchText: "")
            })
        }
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.8
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.bookStates.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = moveToLibraryButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBOutlet weak var moveToLibraryButton: UIButton!
    @IBOutlet weak var noteCollectionView: UICollectionView!
    @IBOutlet weak var bookTitle: UILabel!
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "cell")
        noteCollectionView.dataSource = self
        noteCollectionView.delegate = self
        
        if (type == "library") {
            moveToLibraryButton.setTitle("Change book state", for: UIControl.State.normal)
        } else {
            moveToLibraryButton.setTitle("Move Book to Library", for: UIControl.State.normal)
        }
        
        let size = UIScreen.main.bounds.width - 50
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: size, height: 100)
        noteCollectionView.setCollectionViewLayout(layout, animated: true)
        bookTitle.text = book?.title
        bookAuthor.text = book?.author
        setDescription()
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
        let date = formatter.string(from: book?.notes[indexPath.row].added ?? Date())
        cell.dateLabel.text = date
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
    
    private func setDescription() {
        switch book!.state {
        case .notOwned:
            bookStateLabel.text = "Not owned"
        case .unread:
            bookStateLabel.text = "Not read yet"
        case .reading:
            bookStateLabel.text = "Now reading"
        case .readed:
            bookStateLabel.text = "Already read"
        }
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

extension BookDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bookStates[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.book!.state = BookState(rawValue: bookStates[indexPath.row])!
        setDescription()
        LocalStorageManager.shared.updateLibraryBook(book: self.book!, completion: {() -> () in
            removeTransparentView()
        })
    }
    
    
}
