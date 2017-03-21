//
//  InitialViewController.swift
//  Notes
//
//  Created by Alessandro Musto on 3/1/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit

class InitialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var tableView: UITableView!
  var notes: [Note] = []

  let coreStack = CoreDataStack.store


  override func viewDidLoad() {
    super.viewDidLoad()




    NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: reload)


    tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = self.view.frame
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    view.addSubview(tableView)


    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd(_:)))


  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    coreStack.fetchNotes()
    notes = coreStack.fetchedNotes
    tableView.reloadData()
  }

  func reload(nofitication: Notification) {
    self.coreStack.fetchNotes()
    self.notes = self.coreStack.fetchedNotes
    self.tableView.reloadData()
    print("Calling reload data")

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let note = notes[indexPath.row]
    cell.textLabel?.text = note.title
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dest = NoteViewController()
    let selectedNote = notes[indexPath.row]
    dump(selectedNote)
    dest.note = notes[indexPath.row]
    navigationController?.pushViewController(dest, animated: false)
  }

  func onAdd(_ barItem: UIBarButtonItem) {
    let dest = NoteViewController()
    navigationController?.pushViewController(dest, animated: false)
  }


  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let note = notes[indexPath.row]
      notes.remove(at: indexPath.row)
      coreStack.delete(note: note)
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    }
  }
  
  
  
}


