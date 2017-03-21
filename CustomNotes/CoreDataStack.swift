//
//  CoreDataStack.swift
//  Notes
//
//  Created by Alessandro Musto on 3/2/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import Foundation
import CoreData


final class CoreDataStack {
  

  static let store = CoreDataStack()
  private init() {}


  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }


  var fetchedNotes = [Note]()

  func storeNote(withTitle title: String, onDate date: NSDate) {
    let note = Note(context: context)
    note.title = title
    note.date = date
    try! context.save()
    print("storing notes - before fetch")
    fetchNotes()
  }

  func fetchNotes() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
    let dateSort = NSSortDescriptor(key:"date", ascending:false)
    fetchRequest.sortDescriptors = [dateSort]
    self.fetchedNotes = try! context.fetch(fetchRequest) as! [Note]
  }

  func delete(note: Note) {
    context.delete(note)
    try! context.save()
  }


  lazy var persistentContainer: CustomPersistantContainer = {

    let container = CustomPersistantContainer(name: "NotesModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {

        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  // MARK: - Core Data Saving support

  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {

        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}


class CustomPersistantContainer : NSPersistentContainer {

  static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.sandromusto.notes")!
  let storeDescription = NSPersistentStoreDescription(url: url)

  override class func defaultDirectoryURL() -> URL {
    return url
  }
}
