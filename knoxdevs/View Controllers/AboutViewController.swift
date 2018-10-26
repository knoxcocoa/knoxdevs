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
