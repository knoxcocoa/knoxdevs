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
        self.links = GroupViewModel.getLinks(for: group)
        self.email = group.email
        self.location = group.location
        self.organizers = group.organizers
        
        let images = GroupViewModel.getImages(for: group.name)
        self.icon = images[0]
        self.banner = images[1]
    }
    
    private static func getLinks(for group: Group) -> [LinkViewModel] {
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

    /// image[0] table icon image, image[1] large banner image
    private static func getImages(for groupName: String) -> [UIImage] {
        var images = [UIImage]()

        switch groupName {
        case "Agile Knoxville":
            images.append(UIImage(named: "agile-sm")!)
            images.append(UIImage(named: "agile-lg")!)
            return images
        case "DC 865":
            images.append(UIImage(named: "dc865-sm")!)
            images.append(UIImage(named: "dc865-lg")!)
            return images
        case "DevBeers":
            images.append(UIImage(named: "devbeers-sm")!)
            images.append(UIImage(named: "devbeers-lg")!)
            return images
        case "FunctionalKnox":
            images.append(UIImage(named: "funcknox-sm")!)
            images.append(UIImage(named: "funcknox-lg")!)
            return images
        case "Knoxville CocoaHeads":
            images.append(UIImage(named: "cocoaheads-sm")!)
            images.append(UIImage(named: "cocoaheads-lg")!)
            return images
        case "KnoxPy":
            images.append(UIImage(named: "knoxpy-sm")!)
            images.append(UIImage(named: "knoxpy-lg")!)
            return images
        case "KnoxUX":
            images.append(UIImage(named: "knoxux-sm")!)
            images.append(UIImage(named: "knoxux-lg")!)
            return images
        case "DevOps Knoxville":
            images.append(UIImage(named: "devops-sm")!)
            images.append(UIImage(named: "devops-lg")!)
            return images
        case "Knox.NET":
            images.append(UIImage(named: "knoxnet-sm")!)
            images.append(UIImage(named: "knoxnet-lg")!)
            return images
        case "Knox3dp":
            images.append(UIImage(named: "knox3dp-sm")!)
            images.append(UIImage(named: "knox3dp-lg")!)
            return images
        case "KnoxData":
            images.append(UIImage(named: "knoxdata-sm")!)
            images.append(UIImage(named: "knoxdata-lg")!)
            return images
        case "KnoxDevs":
            images.append(UIImage(named: "knoxdevs-sm")!)
            images.append(UIImage(named: "knoxdevs-lg")!)
            return images
        case "KnoxJava":
            images.append(UIImage(named: "knoxjava-sm")!)
            images.append(UIImage(named: "knoxjava-lg")!)
            return images
        case "KnoxQA":
            images.append(UIImage(named: "knoxqa-sm")!)
            images.append(UIImage(named: "knoxqa-lg")!)
            return images
        case "Knoxville Game Design":
            images.append(UIImage(named: "knoxgame-sm")!)
            images.append(UIImage(named: "knoxgame-lg")!)
            return images
        case "Knoxville JS":
            images.append(UIImage(named: "knoxjs-sm")!)
            images.append(UIImage(named: "knoxjs-lg")!)
            return images
        default:
            images.append(UIImage(named: "default-sm")!)
            images.append(UIImage(named: "default-lg")!)
            return images
        }
    }
}
