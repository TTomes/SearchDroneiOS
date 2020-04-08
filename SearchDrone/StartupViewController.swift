//
//  StartupViewController.swift
//  SearchDrone
//
//  Created by Travis Tomer on 4/2/20.
//  Copyright © 2020 Travis Tomer. All rights reserved.
//

import Foundation
import UIKit

class StartupViewController: UIViewController {

    // Init button refernce
    @IBOutlet weak var openMissionsView: UIButton!
    
    // Override viewDidLoad to apply stylistic changes to button
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMissionsView.layer.cornerRadius = 20
        
    }
        

}
