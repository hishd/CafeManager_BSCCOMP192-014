//
//  StoreViewController.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import UIKit

class StoreViewController: UIViewController {

    @IBOutlet weak var segTabs: UISegmentedControl!
    @IBOutlet weak var containerFood: UIView!
    @IBOutlet weak var containerCategory: UIView!
    @IBOutlet weak var containerMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onSegmentTabChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            containerFood.isHidden = false
            containerCategory.isHidden = true
            containerMenu.isHidden = true
        case 1:
            containerCategory.isHidden = false
            containerFood.isHidden = true
            containerMenu.isHidden = true
        case 2:
            containerMenu.isHidden = false
            containerFood.isHidden = true
            containerCategory.isHidden = true
        default:
            NSLog("Default")
        }
    }
}
