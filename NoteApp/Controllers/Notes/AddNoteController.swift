//
//  AddNoteController.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit
import CoreData

class AddNoteController: UIViewController {

    @IBOutlet weak var addTextField:UITextField!
    @IBOutlet weak var contentField:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTextField.becomeFirstResponder()
    }

    
    @IBAction func save(_ sender:UIButton){
        guard let titleField = addTextField.text, !titleField.isEmpty else {
            showAlert(with: "Woops", content: "Please name your notes!")
            return
        }
        
        let note = Note(context: CoreDataManager.shared.managedContext)
        
        note.createdAt = Date()
        note.updatedAt = Date()
        note.contents = contentField.text
        note.title = addTextField.text
    
        print(note)
        _ = navigationController?.popViewController(animated: true)
    }
}
