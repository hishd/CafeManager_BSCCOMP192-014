//
//  MenuViewController.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var txtItemName: CustomTextField!
    @IBOutlet weak var txtItemDescription: CustomTextField!
    @IBOutlet weak var txtItemPrice: CustomTextField!
    @IBOutlet weak var txtItemCategory: CustomTextField!
    @IBOutlet weak var txtItemDiscount: CustomTextField!
    @IBOutlet weak var switchSellAsItem: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onAddPressed(_ sender: UIButton) {
    }
}
