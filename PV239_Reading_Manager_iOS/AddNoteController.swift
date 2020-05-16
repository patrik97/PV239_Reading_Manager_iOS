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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = "0/100";
    }
    

    @IBAction func textEditedAction(_ sender: UITextField) {
        let currentTextSize = noteText.text?.count
        counterLabel.text = "\(currentTextSize ?? 0)" + "/100"
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
