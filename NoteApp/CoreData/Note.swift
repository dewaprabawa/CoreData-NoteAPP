//
//  Note.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation

struct NoteModel {
    let title:String?
    let contents:String?
    let updatedAt = Date()
    let createdAt = Date()
}
