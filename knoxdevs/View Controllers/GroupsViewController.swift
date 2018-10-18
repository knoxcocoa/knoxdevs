//
//  GroupsViewController.swift
//  knoxdevs
//
//  Created by Gavin on 10/10/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController, UISplitViewControllerDelegate, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    var groups = [GroupViewModel]()
    var groupsFiltered = [GroupViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup split view controller
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        
        // setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Groups and Tags"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // populate groups view model array from database file
        let sqlitedb = SQLiteDatabase()
        
        sqlitedb.getGroups { [weak self] groups, error in
            if let error = error {
                //self?.handleError(error: error)
                print(error)
            }
            if let groups = groups {
                self?.groups = groups
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return groupsFiltered.count
        }
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        let group: GroupViewModel
        if isFiltering() {
            group = groupsFiltered[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.tags
        cell.imageView?.image = group.icon
        return cell
    }
    
    // MARK: - Search controller
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        let text = searchText.lowercased()
        groupsFiltered = groups.filter {
            $0.name.lowercased().contains(text) || $0.tags.contains(text)
        }
        tableView.reloadData()
    }
    
    // Search controller helper methods
    
    func searchBarIsEmpty() -> Bool {
        // returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
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
                let group: GroupViewModel
                if isFiltering() {
                    group = groupsFiltered[indexPath.row]
                } else {
                    group = groups[indexPath.row]
                }
                let groupVC = segue.destination as? GroupViewController
                groupVC?.group = group
            }
        }
    }

}
