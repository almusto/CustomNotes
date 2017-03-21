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

  private var urlString: String?
  private var textString: String?
  var selectedNote: Note!
  let store = CoreDataStack.store
  var notes = [Note]()


  override func viewDidLoad() {
    super.viewDidLoad()


    store.fetchNotes()
    notes = store.fetchedNotes

    let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
    let contentTypeURL = kUTTypeURL as String
    let contentTypeText = kUTTypeText as String

    for attachment in extensionItem.attachments as! [NSItemProvider] {
      if attachment.isURL {
        attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
          let url = results as! URL?
          self.urlString = url!.absoluteString
        })
      }
      if attachment.isText {
        attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil, completionHandler: { (results, error) in
          let text = results as! String
          self.textString = text
          _ = self.isContentValid()
        })
      }
    }
  }

  override func isContentValid() -> Bool {
    if urlString != nil || textString != nil {
      if !contentText.isEmpty {
        return true
      }
    }
    return true
  }

  override func didSelectPost() {
    print(#function)
    guard let text = textView.text else {return}
    print(text)

    if selectedNote == nil {
      if let string = urlString {
        store.storeNote(noteTitle: "\(text)\n\(string)")
      } else {
        store.storeNote(noteTitle: "\(text)")
      }
    } else {
      var currentTitle = selectedNote.title!
      if let string = urlString {
        currentTitle.append("\n\(text)\n\(string)")
        store.update(note: selectedNote, withTitle: currentTitle)
      } else {
        currentTitle.append("\n\(text)")
        store.update(note: selectedNote, withTitle: currentTitle)
        store.saveContext()
      }
    }
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

//MARK: NSItemProvider check



extension NSItemProvider {

  var isURL: Bool {
    return hasItemConformingToTypeIdentifier(kUTTypeURL as String)
  }
  
  var isText: Bool {
    return hasItemConformingToTypeIdentifier(kUTTypeText as String)
  }
  
}



