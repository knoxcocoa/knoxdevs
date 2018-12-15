//
//  OrganizerTableViewCell.swift
//  knoxdevs
//
//  Created by Gavin on 10/14/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit
import SafariServices
import Contacts

class OrganizerTableViewCell: UITableViewCell {

    private var organizer: OrganizerViewModel?
    private var parentVC: UIViewController?

    @IBOutlet weak var organizerIcon: UIImageView!
    @IBOutlet weak var organizerLabel: UILabel!
    
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    func configure(for organizer: OrganizerViewModel, fromVC parent: UIViewController) {
        self.organizer = organizer
        self.parentVC = parent
        self.backgroundColor = Theme.cellBgColor
        organizerIcon.tintColor = Theme.labelTextColor
        organizerLabel.textColor = Theme.labelTextColor
        
        organizerIcon.image = organizer.icon
        organizerLabel.text = organizer.name
        
        if organizer.github == nil {
            githubButton.isEnabled = false
        }
        
        if organizer.twitter == nil {
            twitterButton.isEnabled = false
        }
        
        if organizer.website == nil {
            websiteButton.isEnabled = false
        }
    }

    @IBAction func showWebsite(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            // github button
            guard let parentVC = parentVC, let url = organizer?.github else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredBarTintColor = Theme.tableBgColor
            parentVC.present(safariVC, animated: true, completion: nil)
        case 1:
            // twitter button
            guard let parentVC = parentVC, let url = organizer?.twitter else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredBarTintColor = Theme.tableBgColor
            parentVC.present(safariVC, animated: true, completion: nil)
        case 2:
            // website button
            guard let parentVC = parentVC, let url = organizer?.website else { return }
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredBarTintColor = Theme.tableBgColor
            parentVC.present(safariVC, animated: true, completion: nil)
        default:
            return
        }
    }
    
    // MARK: - Contact
    
    @IBAction func addContact(_ sender: UIButton) {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.saveContact(to: store)
            }
            if let error = error {
                let msg = error.localizedDescription
                self.showErrorAlert(with: msg)
            }
        }
    }
    
    private func saveContact(to store: CNContactStore) {
        
        guard let organizer = organizer else { return }
        let fullname = organizer.name
        let firstlast = fullname.components(separatedBy: " ")
        
        // check for existing contacts
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: fullname)
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        
        do {
            let fetchResults = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            if fetchResults.count > 0 {
                showContactExistsAlert(for: fullname)
                return
            }
        } catch {
            let msg = error.localizedDescription
            self.showErrorAlert(with: msg)
            return
        }
        
        // add contact
        let contact = CNMutableContact()
        contact.imageData = organizer.icon.pngData()
        contact.givenName = firstlast[0]
        contact.familyName = firstlast[1]

        if let user = organizer.twitterName, let twitterUrl = organizer.twitter {
            let social = CNSocialProfile(urlString: "\(twitterUrl)", username: user, userIdentifier: nil, service: CNSocialProfileServiceTwitter)
            let val = CNLabeledValue(label: "Twitter", value: social)
            contact.socialProfiles = [val]
        }
        
        if let website = organizer.website {
            let val = CNLabeledValue(label: CNLabelURLAddressHomePage, value: "\(website)" as NSString)
            contact.urlAddresses = [val]
        }
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            self.showContactSavedAlert(for: fullname)
        } catch {
            let msg = error.localizedDescription
            self.showErrorAlert(with: msg)
        }
    }
    
    private func showContactSavedAlert(for name: String) {
        let msg = "Contact information for \(name) was saved to this device."
        let alertController = UIAlertController(title: "Contact Saved", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.parentVC?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showContactExistsAlert(for name: String) {
        let msg = "Contact information for \(name) already exists in the address book."
        let alertController = UIAlertController(title: "Contact Already Exists", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.parentVC?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showErrorAlert(with message: String) {
        let msg = "Error adding contact: \(message)."
        let alertController = UIAlertController(title: "Contact Error", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.parentVC?.present(alertController, animated: true, completion: nil)
        }
    }

}
