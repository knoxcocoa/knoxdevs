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
    let organizers: [OrganizerViewModel]
    let banner: UIImage

    init(group: Group) {
        self.name = group.name
        self.tags = group.tags
        self.description = group.description
        self.links = GroupViewModel.getLinks(group: group)
        self.email = group.email
        self.location = group.location
        self.organizers = GroupViewModel.getOrganizers(group: group)
        self.banner = GroupViewModel.getImage(name: group.name)
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
    
    private static func getOrganizers(group: Group) -> [OrganizerViewModel] {
        let sqlitedb = SQLiteDatabase()
        
        do {
            try sqlitedb.open()
        } catch SQLiteError.Path(let message) {
            print("\(message)")
        } catch SQLiteError.Open(let message) {
            print("\(message)")
        } catch {
            print("Unexpected error.")
        }
        
        var organizersVM = [OrganizerViewModel]()
        let names = group.organizers.components(separatedBy: ", ")
        
        for n in names {
            if let organizer = sqlitedb.getOrganizer(name: n) {
                let orgvm = OrganizerViewModel(organizer: organizer)
                organizersVM.append(orgvm)
            } else {
                let org = Organizer(id: 0, name: "Cold Beer", twitter: nil, github: nil, website: nil)
                let orgvm = OrganizerViewModel(organizer: org)
                organizersVM.append(orgvm)
            }
        }

        return organizersVM
    }
    
    private static func getImage(name: String) -> UIImage {
        switch name {
        case "DC 865":
            return UIImage(named: "dc865")!
        case "KnoxPy":
            return UIImage(named: "knoxpy")!
        default:
            return UIImage(named: "groups")!
        }
    }
}
