//
//  GroupsViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/14/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation

struct GroupsViewModel {
    
    let groups: [GroupViewModel]
    
    init() {
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
        
        guard let groups = sqlitedb.getGroups() else {
            let group = Group(id: 0, name: "none", tags: "none", website: nil, email: nil, github: nil, twitter: nil, meetup: nil, description: "none", location: "none", organizers: "none")
            let groupVM = GroupViewModel(group: group)
            self.groups = [groupVM]
            return
        }

        self.groups = groups
    }

}
