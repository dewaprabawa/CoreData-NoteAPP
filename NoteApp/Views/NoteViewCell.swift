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
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellViewColor: UIView!
}
