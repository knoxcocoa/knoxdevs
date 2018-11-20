//
//  SettingsViewController.swift
//  knoxdevs
//
//  Created by Gavin on 11/8/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.barStyle == .default ? .default : .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }
    
    private func applyTheme() {
        Theme.configure()
        tabBarController?.tabBar.barStyle = Theme.barStyle
        tableView.backgroundColor = Theme.tableBgColor
        tableView.separatorColor = Theme.separatorColor
        tableView.reloadData()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func applyIcon() {
        switch UserDefaults.standard.integer(forKey: "icon") {
        case 0:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(nil)
            }
        case 1:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName("AppIcon-1")
            }
        case 2:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName("AppIcon-2")
            }
        case 3:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName("AppIcon-3")
            }
        default:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(nil)
            }
        }
    }

    // MARK: - Table view

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // show checkmark and set theme when selecting cells in section 0
        let themeRow = UserDefaults.standard.integer(forKey: "theme")
        let themeCell = tableView.cellForRow(at: IndexPath(row: themeRow, section: 0))
        
        if indexPath.section == 0 {
            if indexPath.row != themeRow {
                themeCell?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            UserDefaults.standard.set(indexPath.row, forKey: "theme")
            applyTheme()
        }
        
        // show checkmark and set app icon when selecting cells in section 1
        let iconRow = UserDefaults.standard.integer(forKey: "icon")
        let iconCell = tableView.cellForRow(at: IndexPath(row: iconRow, section: 1))
        
        if indexPath.section == 1 {
            if indexPath.row != iconRow {
                iconCell?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            UserDefaults.standard.set(indexPath.row, forKey: "icon")
            applyIcon()
        }
        
        // reset user defaults when selecting cell in section 2
        if indexPath.section == 2 {
            themeCell?.accessoryType = .none
            iconCell?.accessoryType = .none
            guard let bundle = Bundle.main.bundleIdentifier else { return }
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            applyTheme()
            applyIcon()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // show checkmark in cell of current theme
        if indexPath.section == 0 {
            if indexPath.row == UserDefaults.standard.integer(forKey: "theme") {
                cell.accessoryType = .checkmark
            }
        }
        
        // show checkmark in cell of current app icon
        if indexPath.section == 1 {
            if indexPath.row == UserDefaults.standard.integer(forKey: "icon") {
                cell.accessoryType = .checkmark
            }
        }
        
        // configure cell appearance from theme colors
        cell.backgroundColor = Theme.cellBgColor
        cell.textLabel?.textColor = Theme.labelTextColor
    }

}
