//
//  CoreDataManager.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import CoreData
import UIKit


struct AddedNote {
    let title:String?
    let contents:String?
    let updatedAt:Date?
    let createdAt:Date?
}

enum CoreDataError:Error{
    case failedToLoadData
    case failedToSaveDAta
}

class CoreDataManager{
    static var shared = CoreDataManager()
    
    private var notes = [AddedNote]()
    
    
    typealias completion = (Result<[AddedNote],Error>) -> Void
    
    var fetchResultController:NSFetchedResultsController<Note>!
    
    init() {
        setupNotificationHandling()
    }
    
    
    func saveNoteCoreData(with model: NoteModel){
        let note = Note(context: CoreDataManager.shared.managedContext)
        note.contents = model.contents
        note.createdAt = model.createdAt
        note.updatedAt = model.updatedAt
        note.title = model.title
    }
    
    
    func updateNoteCoreData(update name: String?, with model: NoteModel){
        guard let name = name else {
            print("predicate name nil")
            return
        }
        
        print("predicate name\(name)")
        
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", name)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)
        request.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: "Note")
        
        do{
            try fetchResultController.performFetch()
            
            if let objectNoteFetched = fetchResultController.fetchedObjects {
                guard objectNoteFetched.count != 0 else {
                    return
                }
                
                let currentNote = objectNoteFetched[0]
                currentNote.setValue(model.title, forKey: "title")
                currentNote.setValue(model.contents, forKey: "contents")
                currentNote.setValue(model.createdAt, forKey: "createdAt")
                currentNote.setValue(model.updatedAt, forKey: "updatedAt")
       
            }
            
            
        }catch let error as NSError{
        print("error:\(error) \(error.userInfo)")
        }
        
    }
    
    func deleteNotInCoreData(at indexPath: IndexPath){
        let deletedNote = fetchResultController.object(at: indexPath)
        CoreDataManager.shared.managedContext.delete(deletedNote)
        
    }
    
    
    func loadNoteAfterFetch(completion:completion){
        
        self.notes.removeAll()
        
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        request.returnsObjectsAsFaults = false
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: "Note")
        
        do{
            try fetchResultController.performFetch()
            
            if let note = fetchResultController.fetchedObjects{
                for i in note {
                    let loadedNote = AddedNote(title: i.title, contents: i.contents, updatedAt: i.updatedAt, createdAt: i.updatedAt)
                    
                    self.notes.append(loadedNote)
                }
                
                let completedNote = self.notes
                
                completion(.success(completedNote))
                
            }else{
                completion(.failure(CoreDataError.failedToLoadData))
            }
            
        }catch let error as NSError{
            print("error:\(error) \(error.userInfo)")
            
        }
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    
    @objc func saveChanges(_ notification: Notification) {
       saves()
    }
    
    private var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteApp")
        
        //Helpers
        let fileManager = FileManager.default
        let storeName = "NoteApp.sqlite"
        
        //URL Documentary
        let documentaryDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let URL = documentaryDirectoryURL.appendingPathComponent(storeName)
        let description = NSPersistentStoreDescription(url: URL)
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
              print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private func setupNotificationHandling(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name:UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    
     private func saves(){
        guard managedContext.hasChanges else { return }
        
        do{
            try managedContext.save()
        }catch{
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
    }
}
