//
//  UIVIewController.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String, content message: String){
        
        let actionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actionController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
    
}
