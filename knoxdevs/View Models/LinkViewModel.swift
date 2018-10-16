//
//  LinkViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/16/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation

enum LinkType: String {
    case website
    case github
    case twitter
    case meetup
}

struct LinkViewModel {
    let type: LinkType
    let url: URL
    
    init(linkType: LinkType, urlString: String) {
        self.type = linkType
        
        switch linkType {
        case .website:
            self.url = URL(string: urlString)!
        case .github:
            self.url = URL(string: "https://github.com/\(urlString)")!
        case .twitter:
            self.url = URL(string: "https://twitter.com/\(urlString)")!
        case .meetup:
            self.url = URL(string: "https://www.meetup.com/\(urlString)")!
        }
    }
}
