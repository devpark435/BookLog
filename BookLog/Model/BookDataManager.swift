//
//  BookDataManager.swift
//  BookLog
//
//  Created by 박현렬 on 5/8/24.
//

import Foundation
import CoreData

class BookDataManager{
    
    static let shared = BookDataManager()
    
    private init(){}
    
    // CoreData Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookLog")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - CRUD Operations
    
    // Create
    func saveBook(book: Book) {
        let managedContext = persistentContainer.viewContext
        let bookEntity = NSEntityDescription.entity(forEntityName: "BookEntity", in: managedContext)!
        let bookObject = NSManagedObject(entity: bookEntity, insertInto: managedContext)
        
        bookObject.setValue(book.title, forKey: "title")
        bookObject.setValue(book.authors.joined(separator: ", "), forKey: "authors")
        bookObject.setValue(book.publisher, forKey: "publisher")
        bookObject.setValue(book.thumbnail, forKey: "thumbnail")
        bookObject.setValue(book.contents, forKey: "contents")
        bookObject.setValue(book.review, forKey: "review")
        // Set other book properties
        
        do {
            try managedContext.save()
            print("Book saved.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
