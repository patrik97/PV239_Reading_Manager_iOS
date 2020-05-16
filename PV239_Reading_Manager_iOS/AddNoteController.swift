//
//  AddNoteController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 16/05/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddNoteController: UIViewController {
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var counterLabel: UILabel!
    var book: Book?
    weak var noteCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = "0/100";
    }
    

    @IBAction func textEditedAction(_ sender: UITextField) {
        let currentTextSize = noteText.text?.count
        counterLabel.text = "\(currentTextSize ?? 0)" + "/100"
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let newNoteText = noteText.text
        if newNoteText?.count ?? 0 < 1 {
            alert(title: book?.author ?? "AAA", message: "Note text cannot be empty")
            return
        }
        if newNoteText?.count ?? 0 > 100 {
            alert(title: "Note was not saved", message: "Note text can have a maximum of 100 characters")
            return
        }
        book?.addNote(note: noteText.text ?? "")
        noteCollectionView?.reloadData()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
