//
//  GroupViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/7/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import UIKit

struct GroupViewModel {

    let name: String
    let tags: String
    let description: String
    let links: [LinkViewModel]
    let email: String?
    let location: String
    let organizers: String
    let icon: UIImage
    let banner: UIImage

    init(group: Group) {
        self.name = group.name
        self.tags = group.tags
        self.description = group.description
        self.links = GroupViewModel.getLinks(group: group)
        self.email = group.email
        self.location = group.location
        self.organizers = group.organizers
        self.icon = GroupViewModel.getIconImage(name: group.name)
        self.banner = GroupViewModel.getBannerImage(name: group.name)
    }
    
    private static func getLinks(group: Group) -> [LinkViewModel] {
        var links = [LinkViewModel]()
        
        if let websiteString = group.website {
            let link = LinkViewModel(linkType: .website, urlString: websiteString)
            links.append(link)
        }
        
        if let githubString = group.github {
            let link = LinkViewModel(linkType: .github, urlString: githubString)
            links.append(link)
        }
        
        if let twitterString = group.twitter {
            let link = LinkViewModel(linkType: .twitter, urlString: twitterString)
            links.append(link)
        }
        
        if let meetupString = group.meetup {
            let link = LinkViewModel(linkType: .meetup, urlString: meetupString)
            links.append(link)
        }

        return links
    }
    
    private static func getIconImage(name: String) -> UIImage {
        switch name {
        case "Agile Knoxville":
            return UIImage(named: "agile-sm")!
        case "DC 865":
            return UIImage(named: "dc865-sm")!
        case "DevBeers":
            return UIImage(named: "devbeers-sm")!
        case "FunctionalKnox":
            return UIImage(named: "funcknox-sm")!
        case "Knoxville CocoaHeads":
            return UIImage(named: "cocoaheads-sm")!
        case "KnoxPy":
            return UIImage(named: "knoxpy-sm")!
        default:
            return UIImage(named: "groups")!
        }
    }

    private static func getBannerImage(name: String) -> UIImage {
        switch name {
        case "Agile Knoxville":
            return UIImage(named: "agile")!
        case "DC 865":
            return UIImage(named: "dc865")!
        case "DevBeers":
            return UIImage(named: "devbeers")!
        case "FunctionalKnox":
            return UIImage(named: "functional")!
        case "Knoxville CocoaHeads":
            return UIImage(named: "cocoaheads")!
        case "KnoxPy":
            return UIImage(named: "knoxpy")!
        default:
            return UIImage(named: "groups")!
        }
    }
}
