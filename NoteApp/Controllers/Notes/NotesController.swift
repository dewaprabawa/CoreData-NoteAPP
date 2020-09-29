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
    

    private lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        
        return fetchedResultController
    }()
    
    //MARK: Segues
    private enum Segue{
        static var AddNote = "addNote"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchNote()
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNote()
        tableView.reloadData()
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
        guard let notes = fetchedResultsController.fetchedObjects else {
            return false
        }
        return notes.count > 0
    }
    
    private let estimatedRowHeight = CGFloat(44.0)

    
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
    
    
    private func fetchNote(){
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }

}


extension NotesController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0}
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteViewCell.reuseIdentifier, for: indexPath) as? NoteViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let note = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = note.title
        return cell
    }
    
     
}


extension NotesController: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//        updateView()
//    }
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
}
