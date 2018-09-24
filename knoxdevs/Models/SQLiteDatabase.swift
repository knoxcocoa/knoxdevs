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
    
    func allGroups() -> [Group]? {
        
        let queryStatementString = "SELECT * FROM groups;"
        var queryStatement: OpaquePointer? = nil
        
        defer { sqlite3_finalize(queryStatement) }
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            var groups = [Group]()
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int64(queryStatement, 0)
                
                let nameText = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: nameText!)
                
                let tagsText = sqlite3_column_text(queryStatement, 2)
                let tags = String(cString: tagsText!)
                
                let descText = sqlite3_column_text(queryStatement, 8)
                let desc = String(cString: descText!)
                
                let group = Group(id: id, name: name, tags: tags, desc: desc)
                groups.append(group)
            }
            return groups
        } else {
            return nil
        }
    }
    
    func getOrganizer(name: String) -> Organizer? {
        
        let queryStatement = "SELECT * FROM organizers WHERE name LIKE \"\(name)\";"
        print(queryStatement)
        var queryOut: OpaquePointer? = nil
        
        defer { sqlite3_finalize(queryOut) }
        
        if sqlite3_prepare_v2(db, queryStatement, -1, &queryOut, nil) == SQLITE_OK {
            
            var organizers = [Organizer]()
            
            while sqlite3_step(queryOut) == SQLITE_ROW {
                let id = sqlite3_column_int64(queryOut, 0)
                
                let nameText = sqlite3_column_text(queryOut, 1)
                let name = String(cString: nameText!)
                
                let twitterText = sqlite3_column_text(queryOut, 2)
                let twitter = String(cString: twitterText!)
                
                let githubText = sqlite3_column_text(queryOut, 3)
                let github = String(cString: githubText!)
                
                let organizer = Organizer(id: id, name: name, twitter: twitter, github: github)
                organizers.append(organizer)
            }
            return organizers[0]
        } else {
            return nil
        }
    }
    
}
