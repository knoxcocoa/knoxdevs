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
    case invalidPath(String)
    case failedOpen(String)
    case invalidQuery(String)
}

class SQLiteDatabase {
    
    private var db: OpaquePointer?
    
    private func getString(from sqlText: UnsafePointer<UInt8>?) -> String? {
        guard let cString = sqlText else {
            return nil
        }
        return String(cString: cString)
    }
    
    func openDatabase() -> SQLiteError? {
        
        guard let path = Bundle.main.path(forResource: "knoxdevs.db", ofType: nil) else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            let error = SQLiteError.invalidPath(errorMessage)
            return error
        }
        
        if sqlite3_open(path, &db) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            let error = SQLiteError.failedOpen(errorMessage)
            return error
        } else {
            return nil
        }
    }
    
    func getGroups(completion: @escaping ([GroupViewModel]?, SQLiteError?) -> Void) {
        
        if let error = openDatabase() {
            completion(nil, error)
            return
        }

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
                
                let group = Group(id: id, name: name, tags: tags, website: website, email: email, github: github, twitter: twitter, meetup: meetup, description: desc, location: loc, organizers: orgs)
                let groupVM = GroupViewModel(group: group)
                groups.append(groupVM)
            }
            
            completion(groups, nil)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            let error = SQLiteError.invalidQuery(errorMessage)
            completion(nil, error)
        }
    }
    
    func getOrganizers(for group: GroupViewModel, completion: @escaping ([OrganizerViewModel]?, SQLiteError?) -> Void) {
        
        if let error = openDatabase() {
            completion(nil, error)
            return
        }

        let namesString = group.organizers
        let namesReplace = namesString.replacingOccurrences(of: ", ", with: "\", \"")
        let names = "\"\(namesReplace)\""
        let queryStatement = "SELECT * FROM organizers WHERE name IN (\(names));"
        var queryOut: OpaquePointer? = nil
        defer { sqlite3_finalize(queryOut) }
        
        if sqlite3_prepare_v2(db, queryStatement, -1, &queryOut, nil) == SQLITE_OK {
            var organizers = [OrganizerViewModel]()
            
            while sqlite3_step(queryOut) == SQLITE_ROW {
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
                let organizerVM = OrganizerViewModel(organizer: organizer)
                organizers.append(organizerVM)
            }
            
            completion(organizers, nil)
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            let error = SQLiteError.invalidQuery(errorMessage)
            completion(nil, error)
        }
    }
    
    func getLocation(for group: GroupViewModel, completion: @escaping (LocationViewModel?, SQLiteError?) -> Void) {
        
        if let error = openDatabase() {
            completion(nil, error)
            return
        }

        let queryStatement = "SELECT * FROM locations WHERE name LIKE \"\(group.location)\";"
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
                
                let location = Location(id: id, name: name, address: address, latitude: lat, longitude: lon, website: website)
                let locationVM = LocationViewModel(location: location)
                
                completion(locationVM, nil)
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                let error = SQLiteError.invalidQuery(errorMessage)
                completion(nil, error)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            let error = SQLiteError.invalidQuery(errorMessage)
            completion(nil, error)
        }
    }

}