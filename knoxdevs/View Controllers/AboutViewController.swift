//
//  AboutViewController.swift
//  knoxdevs
//
//  Created by Gavin on 10/25/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController {
    
    @IBOutlet weak var knoxdevsLabel: UILabel!
    @IBOutlet weak var githubLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.barStyle == .default ? .default : .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyTheme()
    }
    
    private func applyTheme() {
        knoxdevsLabel.textColor = Theme.labelTextColor
        githubLabel.textColor = Theme.labelTextColor
        view.backgroundColor = Theme.viewBgColor
    }

    @IBAction func showWebsite(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // knoxdevs website button
            let url = URL(string: "https://knoxdevs.com")!
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        case 1:
            // knoxville cocoaheads github button
            let url = URL(string: "https://github.com/knoxcocoa")!
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        default:
            return
        }
    }
    
}
