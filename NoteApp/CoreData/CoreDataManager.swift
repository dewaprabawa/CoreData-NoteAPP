//
//  CoreDataManager.swift
//  NoteApp
//
//  Created by Dewa Prabawa on 29/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager{
    static var shared = CoreDataManager()
    
    private var notes = [Note]()
    
    init() {
        setupNotificationHandling()
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
