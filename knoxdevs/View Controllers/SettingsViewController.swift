//
//  SettingsViewController.swift
//  knoxdevs
//
//  Created by Gavin on 11/8/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var darkLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.barStyle == .default ? .default : .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }
    
    private func applyTheme() {
        Theme.configure()
        defaultLabel.textColor = Theme.labelTextColor
        darkLabel.textColor = Theme.labelTextColor
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
        default:
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(nil)
            }
        }
    }

    // MARK: - Table view

    /// Show checkmark and set theme when selecting a row in section 0
    /// Show checkmark and set app icon when selecting a row in section 1
    /// Reset user defaults when selecting cell in section 2
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // theme section
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
        
        // app icon section
        let iconRow = UserDefaults.standard.integer(forKey: "icon")
        let iconCell = tableView.cellForRow(at: IndexPath(row: iconRow, section: 1))
        iconCell?.textLabel?.textColor = Theme.labelTextColor
        
        if indexPath.section == 1 {
            if indexPath.row != iconRow {
                iconCell?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            UserDefaults.standard.set(indexPath.row, forKey: "icon")
            applyIcon()
        }
        
        // reset defaults section
        if indexPath.section == 2 {
            themeCell?.accessoryType = .none
            iconCell?.accessoryType = .none
            guard let bundle = Bundle.main.bundleIdentifier else { return }
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            applyTheme()
            applyIcon()
        }
    }
    
    /// Remove checkmark from cell upon deselection
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    /// Show checkmark in cell of selected theme
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            if indexPath.row == UserDefaults.standard.integer(forKey: "theme") {
                cell.accessoryType = .checkmark
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == UserDefaults.standard.integer(forKey: "icon") {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.backgroundColor = Theme.cellBgColor
    }

}
