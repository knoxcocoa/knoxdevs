//
//  GroupViewController.swift
//  knoxdevs
//
//  Created by Gavin on 8/21/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    let headers = ["Description", "Location", "Links", "Organizers"]
    var links = [Link]()

    var group: GroupViewModel? {
        didSet {
            loadViewIfNeeded()
            
            guard let group = group else { return }
            groupImageView.image = UIImage(named: "people")
            nameLabel.text = group.name
            tagsLabel.text = group.tags
            
            guard let links = group.links else { return }
            self.links = links
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = group else { return 1 }
        
        switch section {
        case 0: // description section
            return 1
        case 1: // location section
            return 1
        case 2: // links section
            return links.count
        case 3: // organizers section
            return group.organizers.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let group = group else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = "none"
            return cell
        }
        
        switch indexPath.section {
        case 0: // description section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = group.description
            return cell
        case 1: // location section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
            cell.textLabel?.text = group.location
            return cell
        case 2: // links section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
            cell.imageView?.image = UIImage(named: links[indexPath.row].type.rawValue)
            cell.textLabel?.text = links[indexPath.row].handle
            return cell
        case 3: // organizers section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = group.organizers[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = "none"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let url = links[indexPath.row].url
            UIApplication.shared.open(url)
        }
    }

}
