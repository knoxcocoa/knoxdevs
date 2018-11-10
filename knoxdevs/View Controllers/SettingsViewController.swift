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

    override func viewDidLoad() {
        super.viewDidLoad()
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

    // MARK: - Table view

    /// Show checkmark and set theme when selecting a row in section 0
    /// Reset user defaults when selecting cell in section 1
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = UserDefaults.standard.integer(forKey: "theme")
        let themeCell = tableView.cellForRow(at: IndexPath(row: theme, section: 0))
        
        if indexPath.section == 0 {
            if indexPath.row != theme {
                themeCell?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            UserDefaults.standard.set(true, forKey: "themeChanged")
            UserDefaults.standard.set(indexPath.row, forKey: "theme")
            applyTheme()
        }
        
        if indexPath.section == 1 {
            themeCell?.accessoryType = .none
            guard let bundle = Bundle.main.bundleIdentifier else { return }
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            applyTheme()
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
        cell.backgroundColor = Theme.cellBgColor
    }

}
