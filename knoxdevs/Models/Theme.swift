//
//  Theme.swift
//  theme
//
//  Created by Gavin on 10/20/18.
//  Copyright © 2018 Gavin. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    static var buttonTextColor = UIColor()      // button text color
    static var labelTextColor = UIColor()       // label text color
    static var viewBgColor = UIColor()          // view background color
    static var barStyle = UIBarStyle.default    // navigation and tab bar style

    static var navBarBgColor = UIColor()        // navigation bar background color
    static var navBarTextColor = UIColor()      // navigation bar item text color
    static var navTitleColor = UIColor()        // navigation bar title text color
    
    static var tabBarBgColor = UIColor()        // tab bar background color

    static var accessoryColor = UIColor()       // table view cell accessory color
    static var cellBgColor = UIColor()          // table view cell background color
    static var separatorColor = UIColor()       // table view separator color
    static var tableBgColor = UIColor()         // table view background color
    
    static func configure() {
        switch UserDefaults.standard.integer(forKey: "theme") {
        case 0:
            Theme.defaultTheme()
        case 1:
            Theme.darkTheme()
        default:
            Theme.defaultTheme()
        }
    }
    
    static func defaultTheme() {
        // General
        buttonTextColor = UIButton().tintColor
        labelTextColor = UILabel().textColor
        viewBgColor = UIColor.white
        barStyle = UIBarStyle.default
        
        // Navigation bar
        navBarTextColor = UINavigationController().navigationBar.tintColor
        navTitleColor = UIColor.black
        
        // Table view
        cellBgColor = UIColor.white
        separatorColor = UIColor(red: 228/255, green: 228/255, blue: 230/255, alpha: 1)
        tableBgColor = UIColor(red: 235/255, green: 235/255, blue: 243/255, alpha: 1)
    }
    
    static func darkTheme() {
        // General
        buttonTextColor = UIColor.yellow
        labelTextColor = UIColor.white
        viewBgColor = UIColor(red: 23/255, green: 32/255, blue: 42/255, alpha: 1)
        barStyle = UIBarStyle.black
        
        // Navigation bar
        navBarBgColor = UIColor.darkGray
        navBarTextColor = UIColor.cyan
        navTitleColor = UIColor.cyan
        
        // Table view
        cellBgColor = UIColor(red: 23/255, green: 32/255, blue: 42/255, alpha: 1)
        separatorColor = UIColor(red: 58/255, green: 68/255, blue: 76/255, alpha: 1)
        tableBgColor = UIColor(red: 17/255, green: 23/255, blue: 29/255, alpha: 1)
    }
    
}
