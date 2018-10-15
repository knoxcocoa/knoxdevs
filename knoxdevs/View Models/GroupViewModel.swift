//
//  GroupViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/7/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import UIKit

enum LinkType: String {
    case website = "website"
    case github = "github"
    case twitter = "twitter"
    case meetup = "meetup"
    case none
}

struct Link {
    let handle: String
    let type: LinkType
    let url: URL
}

struct GroupViewModel {

    let name: String
    let tags: String
    let description: String
    let links: [Link]
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
    
    private static func getLinks(group: Group) -> [Link] {
        var links = [Link]()
        if let website = group.website {
            if let url = URL(string: website) {
                links.append(Link(handle: website, type: .website, url: url))
            }
        }
        if let github = group.github {
            if let url = URL(string: "https://github.com/\(github)") {
                links.append(Link(handle: github, type: .github, url: url))
            }
        }
        if let twitter = group.twitter {
            if let url = URL(string: "https://twitter.com/\(twitter)") {
                links.append(Link(handle: twitter, type: .twitter, url: url))
            }
        }
        if let meetup = group.meetup {
            if let url = URL(string: "https://www.meetup.com/\(meetup)") {
                links.append(Link(handle: meetup, type: .meetup, url: url))
            }
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
