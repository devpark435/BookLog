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
    func saveBook(book: BookEntityModel) {
        let managedContext = persistentContainer.viewContext
        let bookEntity = NSEntityDescription.entity(forEntityName: "BookEntity", in: managedContext)!
        let bookObject = NSManagedObject(entity: bookEntity, insertInto: managedContext)
        
        bookObject.setValue(book.authors, forKey: "authors")
        bookObject.setValue(book.contents, forKey: "contents")
        bookObject.setValue(book.publisher, forKey: "publisher")
        bookObject.setValue(book.thumbnail, forKey: "thumbnail")
        bookObject.setValue(book.title, forKey: "title")
        bookObject.setValue(book.review, forKey: "review")
        
        do {
            try managedContext.save()
            print("Book saved successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Read
    func fetchBooks() -> [BookEntityModel] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookEntity")
        
        do {
            let bookObjects = try managedContext.fetch(fetchRequest)
            var books: [BookEntityModel] = []
            
            for bookObject in bookObjects {
                let authors = bookObject.value(forKey: "authors") as? String ?? ""
                let contents = bookObject.value(forKey: "contents") as? String ?? ""
                let publisher = bookObject.value(forKey: "publisher") as? String ?? ""
                let thumbnail = bookObject.value(forKey: "thumbnail") as? String ?? ""
                let title = bookObject.value(forKey: "title") as? String ?? ""
                let review = bookObject.value(forKey: "review") as? String
                
                let book = BookEntityModel(authors: authors, contents: contents, publisher: publisher, thumbnail: thumbnail, title: title, review: review)
                books.append(book)
            }
            
            print(books)
            
            return books
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
