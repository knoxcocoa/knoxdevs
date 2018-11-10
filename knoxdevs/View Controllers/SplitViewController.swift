//
//  SplitViewController.swift
//  knoxdevs
//
//  Created by Gavin on 11/10/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.barStyle == .default ? .default : .lightContent
    }

}
