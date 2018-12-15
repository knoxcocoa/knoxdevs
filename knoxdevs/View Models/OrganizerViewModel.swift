//
//  OrganizerViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/14/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import UIKit

struct OrganizerViewModel {

    let name: String
    let icon: UIImage
    let twitterName: String?
    let twitter: URL?
    let github: URL?
    let website: URL?

    init(organizer: Organizer) {
        self.name = organizer.name
        self.icon = OrganizerViewModel.getIcon(name: organizer.name)
        
        if let twitterUser = organizer.twitter {
            self.twitterName = twitterUser
        } else {
            self.twitterName = nil
        }
        
        if let twitterString = organizer.twitter, let url = URL(string: twitterString) {
            self.twitter = URL(string: "https://twitter.com/\(url)")
        } else {
            self.twitter = nil
        }
        
        if let githubString = organizer.github, let url = URL(string: githubString) {
            self.github = URL(string: "https://github.com/\(url)")
        } else {
            self.github = nil
        }
        
        if let websiteString = organizer.website, let url = URL(string: websiteString) {
            self.website = url
        } else {
            self.website = nil
        }
    }
    
    private static func getIcon(name: String) -> UIImage {
        switch name {
        case "Gavin Wiggins":
            return UIImage(named: "gavin")!
        case "Bill Morefield":
            return UIImage(named: "bill")!
        case "Andy Cowell":
            return UIImage(named: "andy")!
        case "Arash Farsi":
            return UIImage(named: "arash")!
        case "Cristi Poindexter":
            return UIImage(named: "cristi")!
        case "Christian Biddle":
            return UIImage(named: "christian")!
        case "Chris Love":
            return UIImage(named: "chris")!
        case "Joe Gray":
            return UIImage(named: "joe")!
        case "James Harrell":
            return UIImage(named: "james")!
        case "Emily E":
            return UIImage(named: "emily")!
        case "Reid Evans":
            return UIImage(named: "reid")!
        case "Cameron Presley":
            return UIImage(named: "cameron")!
        case "Dennis Stepp":
            return UIImage(named: "dennis")!
        case "Jamie Phillips":
            return UIImage(named: "jamie")!
        case "Alex Pawlowski":
            return UIImage(named: "alex")!
        case "Will Sames":
            return UIImage(named: "will")!
        case "Ken Cavagnolo":
            return UIImage(named: "ken")!
        case "James Horey":
            return UIImage(named: "jamesh")!
        case "Cody Lambert":
            return UIImage(named: "cody")!
        case "Christopher Lamm":
            return UIImage(named: "christopher")!
        case "Kris Ann":
            return UIImage(named: "kris")!
        case "Adrian Carr":
            return UIImage(named: "adrian")!
        case "Brant Boehmann":
            return UIImage(named: "brant")!
        case "Wade Chandler":
            return UIImage(named: "wade")!
        case "Katie Cleveland":
            return UIImage(named: "katie")!
        case "Jameson McGhee":
            return UIImage(named: "jameson")!
        case "Mark Kelly":
            return UIImage(named: "mark")!
        case "Shane":
            return UIImage(named: "shane")!
        case "Levi Smith":
            return UIImage(named: "levi")!
        case "Josh Carroll":
            return UIImage(named: "josh")!
        case "Arlene Rose":
            return UIImage(named: "arlene")!
        case "Christine Jones":
            return UIImage(named: "christine")!
        case "James Broyles":
            return UIImage(named: "broyles")!
        case "Michael Mizner":
            return UIImage(named: "michael")!
        case "Daryl":
            return UIImage(named: "daryl")!
        case "Doug Laney":
            return UIImage(named: "doug")!
        case "Laurie Kay":
            return UIImage(named: "laurie")!
        default:
            return UIImage(named: "groups")!
        }
    }
}
