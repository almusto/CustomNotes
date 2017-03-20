//
//  ShareViewController.swift
//  AddNote
//
//  Created by Alessandro Musto on 3/12/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import CoreData


class ShareViewController: SLComposeServiceViewController {

  private var urlString: URL?
  var selectedNote: Note!
  var notes = [Note]()


  override func viewDidLoad() {
    super.viewDidLoad()

//    makeNotes()
    getNotes()

    let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
    let contentTypeURL = kUTTypeURL as String
    let contentTypeText = kUTTypeText as String

    for attachment in extensionItem.attachments as! [NSItemProvider] {
      if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {

        attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
          let url = results as! URL?
          self.urlString = url

        })
      }

      if attachment.hasItemConformingToTypeIdentifier(contentTypeText) {
        attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil, completionHandler: { (results, error) in
          let text = results as! String
          print(text)

        })

      }
    }

  }

  override func isContentValid() -> Bool {
    if urlString != nil {
      if !contentText.isEmpty {
        return true
      }
    }
    return false
  }

  override func didSelectPost() {

    let configName = "com.shinobicontrols.ShareAlike.BackgroundSessionConfig"
    let sessionConfig = URLSessionConfiguration.background(withIdentifier: configName)
    // Extensions aren't allowed their own cache disk space. Need to share with application
    sessionConfig.sharedContainerIdentifier = "group.com.sandromusto.notes"
    let session = URLSession(configuration: sessionConfig)


    extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)


  }


  override func configurationItems() -> [Any]! {
    let item = SLComposeSheetConfigurationItem()
    item?.title = "Selected Note"
    item?.value = selectedNote?.title ?? "New Note"
    item?.tapHandler = {
      let vc = ShareSelectTVC()
      vc.delegate = self
      vc.userNotes = self.notes
      self.pushConfigurationViewController(vc)
    }
    return [item]
  }

}

//MARK: ShareSelectDelegate

extension ShareViewController: ShareSelectViewControllerDelegate {
  func selected(note: Note) {
    selectedNote = note
    reloadConfigurationItems()
    popConfigurationViewController()
  }
}

//MARK: Populate Notes from CoreData

extension ShareViewController {

  func getNotes() {
    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.sandromusto.notes")?.appendingPathComponent("NotesModel.sqlite")
    let test = NSPersistentStoreDescription(url: url!)

    let container = NSPersistentContainer(name: "NotesModel")

    container.persistentStoreDescriptions = [test]
    container.loadPersistentStores {(storeDescription, error) in }

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
    notes = try! container.viewContext.fetch(fetchRequest) as! [Note]


  }
}



