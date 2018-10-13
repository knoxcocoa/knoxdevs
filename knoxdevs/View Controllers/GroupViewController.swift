//
//  GroupViewController.swift
//  knoxdevs
//
//  Created by Gavin on 8/21/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit
import SafariServices

class GroupViewController: UITableViewController {
    
    let sqlitedb = SQLiteDatabase()
    let headers = ["Banner", "Description", "Location", "Links", "Organizers", "Contact"]
    var links = [Link]()
    var location: LocationViewModel?
    
    var group: GroupViewModel? {
        didSet {
            loadViewIfNeeded()
            guard let group = group else { return }
            self.links = group.links
            
            // open sqlite database and get location for group
            do {
                try sqlitedb.open()
            } catch SQLiteError.Path(let message) {
                print("\(message)")
            } catch SQLiteError.Open(let message) {
                print("\(message)")
            } catch {
                print("Unexpected error.")
            }
            guard let location = sqlitedb.getLocation(name: group.location) else { return }
            self.location = location
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        case 0:
            // banner section
            return 1
        case 1:
            // description section
            return 1
        case 2:
            // location section
            return 1
        case 3:
            // links section
            return links.count
        case 4:
            // organizers section
            return group.organizers.count
        case 5:
            // contact section
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let group = group, let location = location else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = "none"
            return cell
        }
        
        switch indexPath.section {
        case 0:
            // banner section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerTableViewCell
            cell.bannerImageView.image = group.image
            cell.groupName.text = group.name
            cell.groupTags.text = group.tags
            return cell
        case 1:
            // description section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = group.description
            return cell
        case 2:
            // location section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
            cell.locationLabel.text = location.description
            return cell
        case 3:
            // links section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
            cell.imageView?.image = UIImage(named: links[indexPath.row].type.rawValue)
            cell.textLabel?.text = links[indexPath.row].handle
            return cell
        case 4:
            // organizers section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = group.organizers[indexPath.row]
            return cell
        case 5:
            // contact section
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath)
            guard let email = group.email else {
                cell.textLabel?.text = "Email address not available"
                cell.selectionStyle = .none
                cell.accessoryType = .none
                return cell
            }
            cell.textLabel?.text = email
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = "none"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            // location section
            guard let url = location?.website else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        case 3:
            // links section
            let url = links[indexPath.row].url
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        case 5:
            // contact section
            guard let email = group?.email else { return }
            guard let url = URL(string: "mailto:\(email)") else { return }
            UIApplication.shared.open(url)
        default:
            return
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            return 200
//        }
//        return uitableviewautomatic
//    }

}
