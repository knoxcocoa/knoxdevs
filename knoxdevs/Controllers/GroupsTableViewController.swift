//
//  GroupsTableViewController.swift
//  knoxdevs
//
//  Created by Gavin on 8/21/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    let sqlitedb = SQLiteDatabase()
    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup split view controller
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        
        // open sqlite database and populate groups array
        do {
            try sqlitedb.open()
        } catch SQLiteError.Path(let message) {
            print("\(message)")
        } catch SQLiteError.Open(let message) {
            print("\(message)")
        } catch {
            print("Unexpected error.")
        }
        guard let allGroups = sqlitedb.allGroups() else { return }
        groups = allGroups
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row].name
        cell.detailTextLabel?.text = groups[indexPath.row].tags
        cell.imageView?.image = UIImage(named: "people")
        return cell
    }
    
    // MARK: - Split view controller
    
    /*
     By returning "true" from this UISplitViewControllerDelegate method,
     the Root View Controller Scene will be shown as the default view on the iPhone.
     */
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let groupVC = segue.destination as? GroupViewController
                groupVC?.group = groups[indexPath.row]
            }
        }
    }

}
