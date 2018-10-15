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
    
    let headers = ["", "Description", "Location", "Links", "Organizers", "Contact"]
    var links = [Link]()
    var location: LocationViewModel?
    
    var group: GroupViewModel? {
        didSet {
            loadViewIfNeeded()
            guard let group = group else { return }
            self.links = group.links
            self.location = LocationViewModel(locationName: group.location)
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
        case 0:
            return 1    // banner section
        case 1:
            return 1    // description section
        case 2:
            return 1    // location section
        case 3:
            return links.count  // links section
        case 4:
            return group.organizers.count   // organizers section
        case 5:
            return 1    // contact section
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
            cell.bannerImageView.image = group.banner
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
            cell.parentVC = self
            cell.mapView.setRegion(location.region, animated: true)
            cell.mapView.addAnnotation(location.annotation)
            cell.locationLabel.text = location.description
            cell.locationUrl = location.website
            return cell
        case 3:
            // links section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
            cell.imageView?.image = UIImage(named: links[indexPath.row].type.rawValue)
            cell.textLabel?.text = links[indexPath.row].handle
            return cell
        case 4:
            // organizers section
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizerCell", for: indexPath) as! OrganizerTableViewCell
            let organizer = group.organizers[indexPath.row]
            cell.parentVC = self
            cell.organizerIcon.image = organizer.icon
            cell.organizerLabel.text = organizer.name
            cell.configureGithub(for: organizer.github)
            cell.configureTwitter(for: organizer.twitter)
            cell.configureWebsite(for: organizer.website)
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
    
}
