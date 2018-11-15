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
    
    let headers = ["", "Description", "Meeting Location", "Group Links", "Organizers", "Contact"]
    var location: LocationViewModel?
    var organizers: [OrganizerViewModel]?

    var group: GroupViewModel? {
        didSet {
            loadViewIfNeeded()
            guard let group = group else { return }
            navigationItem.title = group.name
            getOrganizersAndLocationFor(group: group)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }
    
    private func applyTheme() {
        Theme.configure()
        navigationController?.navigationBar.barStyle = Theme.barStyle
        tabBarController?.tabBar.barStyle = Theme.barStyle
        tableView.backgroundColor = Theme.tableBgColor
        tableView.separatorColor = Theme.separatorColor
        tableView.reloadData()
    }
    
    private func getOrganizersAndLocationFor(group: GroupViewModel) {
        let sqlitedb = SQLiteDatabase()
        
        sqlitedb.getOrganizers(for: group) { [weak self] organizers, error in
            if let error = error {
                self?.handleError(error: error)
            }
            if let organizers = organizers {
                self?.organizers = organizers
            }
        }
        
        sqlitedb.getLocation(for: group) { [weak self] location, error in
            if let error = error {
                self?.handleError(error: error)
            }
            if let location = location {
                self?.location = location
            }
        }
    }
    
    private func handleError(error: SQLiteError) {
        var errorMessage = ""
        switch error {
        case .invalidPath(let message):
            errorMessage = "Invalid path \(message)."
        case .failedOpen(let message):
            errorMessage = "Faild to open database \(message)."
        case .invalidQuery(let message):
            errorMessage = "Invalid query \(message)."
        }
        let alertController = UIAlertController(title: "SQLite Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = group, let organizers = organizers else { return 1 }
        
        switch section {
        case 3:
            return group.links.count    // links section
        case 4:
            return organizers.count     // organizers section
        default:
            return 1    // banner, description, location, and contact sections
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let group = group, let organizers = organizers, let location = location else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.backgroundColor = Theme.cellBgColor
            cell.textLabel?.text = "none"
            return cell
        }
        
        switch indexPath.section {
        case 0:
            // banner section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerTableViewCell
            cell.backgroundColor = Theme.cellBgColor
            cell.bannerImageView.image = group.banner
            cell.groupName.text = group.name
            cell.groupTags.text = group.tags
            cell.groupName.textColor = Theme.labelTextColor
            cell.groupTags.textColor = Theme.labelTextColor
            return cell
        case 1:
            // description section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.backgroundColor = Theme.cellBgColor
            cell.textLabel?.text = group.description
            cell.textLabel?.textColor = Theme.labelTextColor
            return cell
        case 2:
            // location section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
            cell.parentVC = self
            cell.backgroundColor = Theme.cellBgColor
            cell.mapView.setRegion(location.region, animated: true)
            cell.mapView.addAnnotation(location.annotation)
            cell.locationLabel.text = location.description
            cell.locationLabel.textColor = Theme.labelTextColor
            cell.locationUrl = location.website
            return cell
        case 3:
            // links section
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
            cell.backgroundColor = Theme.cellBgColor
            cell.imageView?.image = UIImage(named: group.links[indexPath.row].type.rawValue)
            cell.imageView?.tintColor = Theme.labelTextColor
            cell.textLabel?.text = group.links[indexPath.row].type.rawValue
            cell.textLabel?.textColor = Theme.labelTextColor
            return cell
        case 4:
            // organizers section
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizerCell", for: indexPath) as! OrganizerTableViewCell
            cell.parentVC = self
            cell.backgroundColor = Theme.cellBgColor
            let organizer = organizers[indexPath.row]
            cell.configureGithub(for: organizer.github)
            cell.configureTwitter(for: organizer.twitter)
            cell.configureWebsite(for: organizer.website)
            cell.organizerIcon.image = organizer.icon
            cell.organizerIcon.tintColor = Theme.labelTextColor
            cell.organizerLabel.text = organizer.name
            cell.organizerLabel.textColor = Theme.labelTextColor
            return cell
        case 5:
            // contact section
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath)
            cell.backgroundColor = Theme.cellBgColor
            guard let email = group.email else {
                cell.accessoryType = .none
                cell.imageView?.tintColor = Theme.labelTextColor
                cell.selectionStyle = .none
                cell.textLabel?.text = "Email address not available"
                cell.textLabel?.textColor = Theme.labelTextColor
                return cell
            }
            cell.imageView?.tintColor = Theme.labelTextColor
            cell.textLabel?.text = email
            cell.textLabel?.textColor = Theme.labelTextColor
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.backgroundColor = Theme.cellBgColor
            cell.textLabel?.text = "none"
            cell.textLabel?.textColor = Theme.labelTextColor
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            // links section
            guard let url = group?.links[indexPath.row].url else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredBarTintColor = Theme.tableBgColor
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
