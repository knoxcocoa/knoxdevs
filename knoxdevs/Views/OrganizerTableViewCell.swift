//
//  OrganizerTableViewCell.swift
//  knoxdevs
//
//  Created by Gavin on 10/14/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit
import SafariServices

class OrganizerTableViewCell: UITableViewCell {

    var githubUrl: URL?
    var twitterUrl: URL?
    var websiteUrl: URL?
    var parentVC: UIViewController?

    @IBOutlet weak var organizerIcon: UIImageView!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!

    @IBAction func showWebsite(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // github button
            print("github pressed")
            guard let parentVC = parentVC, let url = githubUrl else { return }
            let safariVC = SFSafariViewController(url: url)
            parentVC.present(safariVC, animated: true, completion: nil)
        case 1:
            // twitter button
            print("twitter pressed")
            guard let parentVC = parentVC, let url = twitterUrl else { return }
            let safariVC = SFSafariViewController(url: url)
            parentVC.present(safariVC, animated: true, completion: nil)
        case 2:
            // website button
            print("website pressed")
            guard let parentVC = parentVC, let url = websiteUrl else { return }
            let safariVC = SFSafariViewController(url: url)
            parentVC.present(safariVC, animated: true, completion: nil)
        default:
            return
        }
    }

    func configureGithub(for url: URL?) {
        if let url = url {
            githubUrl = url
        } else {
            githubButton.isEnabled = false
        }
    }
    
    func configureTwitter(for url: URL?) {
        if let url = url {
            twitterUrl = url
        } else {
            twitterButton.isEnabled = false
        }
    }
    
    func configureWebsite(for url: URL?) {
        if let url = url {
            websiteUrl = url
        } else {
            websiteButton.isEnabled = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
