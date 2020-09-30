//
//  DetailNoteController.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 30/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class DetailNoteController: UIViewController {
    
    var currentNote:AddedNote?
    
    @IBOutlet weak var addTextField:UITextField!
    @IBOutlet weak var contentsField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextField.text = currentNote?.title
        contentsField.text = currentNote?.contents
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let text = addTextField.text, !text.isEmpty else {
            return
        }
        
        CoreDataManager.shared.updateNoteCoreData(update: currentNote?.title, with: NoteModel(title: addTextField.text, contents: contentsField.text))
        
    }
}
