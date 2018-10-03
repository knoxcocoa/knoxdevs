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
    
    let headers = ["Description", "Organizers"]
    
    var group: Group? {
        didSet {
            updateTopView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateTopView() {
        loadViewIfNeeded()
        if let group = group {
            groupImageView.image = UIImage(named: "people")
            nameLabel.text = group.name
            tagsLabel.text = group.tags
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
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath)
        cell.textLabel?.text = group?.desc
        return cell
    }

}
