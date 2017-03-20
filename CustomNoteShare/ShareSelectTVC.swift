//
//  ShareSelectTVC.swift
//  Notes
//
//  Created by Alessandro Musto on 3/16/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit
import CoreData


protocol ShareSelectViewControllerDelegate: class {
  func selected(note: Note)
}



class ShareSelectTVC: UITableViewController, URLSessionDelegate {


  var userNotes = [Note]()
  let reuseIdentifier = "noteCell"

  weak var delegate: ShareSelectViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
      title = "Select Note"

      tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNotes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = userNotes[indexPath.row].title

        return cell
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.selected(note: userNotes[indexPath.row])
    }
  }


}




