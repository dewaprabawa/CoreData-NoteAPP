//
//  ViewController.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit
import CoreData

class NotesController: UIViewController{

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageNoContentLabel:UILabel!
    

    private var notes = [AddedNote]()
    
    //MARK: Segues
    private enum Segue{
        static var AddNote = "addNote"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchNotes()
        updateView()
    }
    
    private func setupViews(){
        tableViewSetups()
        setupMessageLabel()
    }
    
    private func tableViewSetups(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteViewCell.nib(), forCellReuseIdentifier: NoteViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        setupMessageLabel()
    }
    
    private var isNoteCount:Bool{
        return notes.count > 0
    }
    
    private let estimatedRowHeight = CGFloat(55.0)

    
    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()
    
    private func setupMessageLabel() {
        messageNoContentLabel.text = "You don't have any notes yet."
    }
    
    private func updateView(){
        tableView.isHidden = !isNoteCount
        messageNoContentLabel.isHidden = isNoteCount
    }
    
    
    private func fetchNotes(){
        
        CoreDataManager.shared.loadNoteAfterFetch { (result) in
            switch(result){
            case .success(let downloadedNote):
                self.notes = downloadedNote
                self.tableView.reloadData()
            case .failure(_):
                fatalError("failed to load note in tableView")
            }
        }
        
    }

}


extension NotesController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = estimatedRowHeight
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteViewCell.reuseIdentifier, for: indexPath) as? NoteViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let note = notes[indexPath.row]
        cell.titleLabel.text = note.title
        cell.contentLable.text = note.contents
        cell.dateLabel.text = updatedAtDateFormatter.string(from: note.updatedAt!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.shared.deleteNotInCoreData(at: indexPath)
        }
        
    
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.insertRows(at: [indexPath], with: .fade)
    
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let edittedNote = notes[indexPath.row]
     
        guard let vc = storyboard?.instantiateViewController(identifier: "DetailNoteController") as? DetailNoteController else {
            return
        }
        vc.currentNote = edittedNote
        _ = navigationController?.pushViewController(vc, animated: true)
    }
    
     
}



