//
//  OrderDetailViewController.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import UIKit

class OrderDetailViewController: BaseViewController {

    @IBOutlet weak var containerViewStatus: UIView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblArrival: UILabel!
    @IBOutlet weak var tblOrderItems: UITableView!
    @IBOutlet weak var btnReadyOrDone: UIButton!
    @IBOutlet weak var lblOrderID: UILabel!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        containerViewStatus.generateRoundView()
        
        if self.order?.orderStatus != .ORDER_PREPERATION && self.order?.orderStatus != .ORDER_READY {
            btnReadyOrDone.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseOP.delegate = self
        if self.order == nil {
            displayErrorMessage(message: "Order information not found", completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
        if self.order?.orderStatus == .ORDER_PREPERATION {
            btnReadyOrDone.setTitle("Ready", for: .normal)
        }
        if self.order?.orderStatus == .ORDER_READY {
            btnReadyOrDone.setTitle("Complete Order", for: .normal)
        }
        
        firebaseOP.getUserLocationUpdates(order: self.order!)
        lblArrival.text = "Ready to arrive"
        lblOrderStatus.text = self.order!.orderStatus.rawValue
        lblOrderID.text = order?.orderID
    }

    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCallCustomerPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func onReadyOrDonePressed(_ sender: UIButton) {
        displayProgress()
        
        if self.order?.orderStatus == .ORDER_PREPERATION {
            firebaseOP.changeOrderStatus(order: self.order!, status: 2)
        }
        
        if self.order?.orderStatus == .ORDER_READY {
            firebaseOP.changeOrderStatus(order: self.order!, status: 4)
        }
            
    }
    
    func registerNIB() {
        tblOrderItems.register(UINib(nibName: OrderItemInfoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: OrderItemInfoTableViewCell.reuseIdentifier)
    }
}

extension OrderDetailViewController: FirebaseActions {
    func onConnectionLost() {
        refreshControl.endRefreshing()
        dismissProgress()
        displayWarningMessage(message: "Please check internet connection", completion: nil)
    }
    func onOrderStatusChanged(status: Int) {
        dismissProgress()
        displaySuccessMessage(message: "Order status changed!", completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    func onOrderStatusNotChanged() {
        dismissProgress()
        displayErrorMessage(message: "Failed to change order status!", completion: nil)
    }
    func onCustomerLocationUpdated(status: Int) {
        if status == 3 {
            lblOrderStatus.text = "Arrived"
            lblArrival.text = "On the way!"
            displayInfoMessage(message: "The customer is on the way", completion: nil)
        } else {
            lblOrderStatus.text = "Ready"
            lblArrival.text = ""
        }
    }
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.orderItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemInfoTableViewCell.reuseIdentifier, for: indexPath) as! OrderItemInfoTableViewCell
        cell.selectionStyle = .none
        cell.configureCell(qty: order?.orderItems[indexPath.row].qty ?? 0, foodDescription: order?.orderItems[indexPath.row].foodItem.foodName ?? "", price: order?.orderItems[indexPath.row].foodItem.discountedPrice.lkrString ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0.01 * Double(indexPath.row), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
                       options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
                       })
    }
}
