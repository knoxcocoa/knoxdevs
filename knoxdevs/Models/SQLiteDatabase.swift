//
//  SQLiteDatabase.swift
//  knoxdevs
//
//  Created by Gavin on 8/26/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case Path(message: String)
    case Open(message: String)
}

class SQLiteDatabase {
    
    fileprivate var db: OpaquePointer?
    
    func open() throws {
        guard let path = Bundle.main.path(forResource: "knoxdevs.db", ofType: nil) else {
            throw SQLiteError.Path(message: "Error with path to sqlite database file.")
        }
        if sqlite3_open(path, &db) != SQLITE_OK {
            throw SQLiteError.Open(message: "Error opening sqlite database.")
        }
    }
    
    private func getString(from sqlText: UnsafePointer<UInt8>?) -> String? {
        guard let cString = sqlText else {
            return nil
        }
        return String(cString: cString)
    }
    
    func getGroups() -> [GroupViewModel]? {
        let queryStatementString = "SELECT * FROM groups;"
        var queryStatement: OpaquePointer? = nil
        defer { sqlite3_finalize(queryStatement) }
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            var groups = [GroupViewModel]()
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int64(queryStatement, 0)
                
                let nameText = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: nameText!)
                
                let tagsText = sqlite3_column_text(queryStatement, 2)
                let tags = String(cString: tagsText!)
                
                let websiteText = sqlite3_column_text(queryStatement, 3)
                let website = getString(from: websiteText)
                
                let emailText = sqlite3_column_text(queryStatement, 4)
                let email = getString(from: emailText)
                
                let githubText = sqlite3_column_text(queryStatement, 5)
                let github = getString(from: githubText)
                
                let twitterText = sqlite3_column_text(queryStatement, 6)
                let twitter = getString(from: twitterText)
                
                let meetupText = sqlite3_column_text(queryStatement, 7)
                let meetup = getString(from: meetupText)
                
                let descriptionText = sqlite3_column_text(queryStatement, 8)
                let desc = String(cString: descriptionText!)
                
                let locationText = sqlite3_column_text(queryStatement, 9)
                let loc = String(cString: locationText!)
                
                let organizersText = sqlite3_column_text(queryStatement, 10)
                let orgs = String(cString: organizersText!)
                
                let group = Group(id: id, name: name, tags: tags, website: website, email: email,
                                  github: github, twitter: twitter, meetup: meetup,
                                  description: desc, location: loc, organizers: orgs)
                let groupVM = GroupViewModel(group: group)
                groups.append(groupVM)
            }
            return groups
        } else {
            return nil
        }
    }
    
    func getOrganizer(name: String) -> Organizer? {
        
        let queryStatement = "SELECT * FROM organizers WHERE name LIKE \"\(name)\";"
        var queryOut: OpaquePointer? = nil
        defer { sqlite3_finalize(queryOut) }
        
        if sqlite3_prepare_v2(db, queryStatement, -1, &queryOut, nil) == SQLITE_OK {
            
            if sqlite3_step(queryOut) == SQLITE_ROW {
                let id = sqlite3_column_int64(queryOut, 0)
                
                let nameText = sqlite3_column_text(queryOut, 1)
                let name = String(cString: nameText!)
                
                let twitterText = sqlite3_column_text(queryOut, 2)
                let twitter = getString(from: twitterText)
                
                let githubText = sqlite3_column_text(queryOut, 3)
                let github = getString(from: githubText)
                
                let websiteText = sqlite3_column_text(queryOut, 4)
                let website = getString(from: websiteText)
                
                let organizer = Organizer(id: id, name: name, twitter: twitter, github: github, website: website)
                return organizer
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getLocation(name: String) -> Location? {
        let queryStatement = "SELECT * FROM locations WHERE name LIKE \"\(name)\";"
        var queryOut: OpaquePointer? = nil
        defer { sqlite3_finalize(queryOut) }

        if sqlite3_prepare_v2(db, queryStatement, -1, &queryOut, nil) == SQLITE_OK {
            
            if sqlite3_step(queryOut) == SQLITE_ROW {
                let id = sqlite3_column_int64(queryOut, 0)
                
                let nameText = sqlite3_column_text(queryOut, 1)
                let name = String(cString: nameText!)
                
                let addressText = sqlite3_column_text(queryOut, 2)
                let address = String(cString: addressText!)
                
                let lat = sqlite3_column_double(queryOut, 3)
                let lon = sqlite3_column_double(queryOut, 4)
                
                let websiteText = sqlite3_column_text(queryOut, 5)
                let website = String(cString: websiteText!)
                
                return Location(id: id, name: name, address: address, latitude: lat, longitude: lon, website: website)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}
