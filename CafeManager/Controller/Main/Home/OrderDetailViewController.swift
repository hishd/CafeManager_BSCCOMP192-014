//
//  OrderDetailViewController.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var containerViewStatus: UIView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblArrival: UILabel!
    @IBOutlet weak var tblOrderItems: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        containerViewStatus.generateRoundView()
    }

    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCallCustomerPressed(_ sender: UIButton) {
    }
}
