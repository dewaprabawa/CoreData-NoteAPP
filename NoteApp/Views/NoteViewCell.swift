//
//  NoteViewCell.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NoteTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
