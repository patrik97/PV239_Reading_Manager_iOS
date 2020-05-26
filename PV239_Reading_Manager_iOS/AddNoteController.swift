//
//  AddNoteController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 16/05/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

private let LIBRARY_BOOKS_KEY = "library_books"

class AddNoteController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    var book: Book?
    weak var noteCollectionView: UICollectionView?
    // TODO: Replace with type struct -> "library" or "wished"
    var type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = "0/100";
        noteTextField.delegate = self
        let borderGray = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        noteTextField.layer.borderColor = borderGray.cgColor
        noteTextField.layer.borderWidth = 0.5
        noteTextField.layer.cornerRadius = 5
        noteTextField.text = "Add note text"
        noteTextField.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextField.textColor == UIColor.lightGray {
            noteTextField.text = nil
            noteTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentTextSize = noteTextField.text.count
        counterLabel.text = "\(currentTextSize)" + "/100"
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let newNoteText = noteTextField.text
        if newNoteText?.count ?? 0 < 1 {
            alert(title: "Error", message: "Note text cannot be empty")
            return
        }
        if newNoteText?.count ?? 0 > 100 {
            alert(title: "Note was not saved", message: "Note text can have a maximum of 100 characters")
            return
        }
        book?.addNote(note: noteTextField.text ?? "")
        
        if (type == "library") {
            LocalStorageManager.shared.updateLibraryBook(book: book!, completion: {() -> () in return})
        }
        
        if (type == "wished") {
            LocalStorageManager.shared.updateWishedBook(book: book!, completion: {() -> () in return})
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        noteCollectionView?.reloadData()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension MyLibraryController {
    private func persistLibraryBooks() {
        do {
            let booksAsJson = try JSONEncoder().encode(myBooks)
            UserDefaults.standard.set(booksAsJson, forKey: LIBRARY_BOOKS_KEY)
        } catch (let error) {
            print("Error when saving library books: \(error)")
        }
    }
}
