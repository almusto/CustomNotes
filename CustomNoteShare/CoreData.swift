//
//  CoreData.swift
//  CustomNotes
//
//  Created by Alessandro Musto on 3/20/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import Foundation
import CoreData



final class CoreDataStack {


  static let store = CoreDataStack()
  private init() {}
  private var container: NSPersistentContainer!


  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }


  var fetchedNotes = [Note]()

  func storeNote(noteTitle: String) {
    let note = Note(context: context)
    note.title = noteTitle
    try! context.save()
  }


  func fetchNotes() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
    self.fetchedNotes = try! context.fetch(fetchRequest) as! [Note]
  }

  lazy var persistentContainer: NSPersistentContainer = {

    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.sandromusto.notes")?.appendingPathComponent("NotesModel.sqlite")
    let test = NSPersistentStoreDescription(url: url!)

    let container = NSPersistentContainer(name: "NotesModel")

    container.persistentStoreDescriptions = [test]
    container.loadPersistentStores {(storeDescription, error) in }
    return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
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

