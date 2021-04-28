//
//  OrderItemTableViewCell.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-29.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerAcceptReject: UIStackView!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var containerOrderStatus: UIView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    
    class var reuseIdentifier: String {
        return "orderItemReuseIdentifier"
    }
    
    class var nibName: String {
        return "OrderItemTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onRejectPressed(_ sender: UIButton) {
    }
    @IBAction func onAcceptPressed(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Order) {
        if order.orderStatus == .ORDER_PENDING {
            containerAcceptReject.isHidden = false
            containerOrderStatus.isHidden = true
        } else {
            containerAcceptReject.isHidden = true
            containerOrderStatus.isHidden = false
        }
        
        lblOrderID.text = order.orderID
        lblCustomerName.text = order.customername
        lblItemCount.text = "\(order.itemCount) Items"
        lblOrderStatus.text = order.orderStatus.rawValue
        lblOrderTotal.text = order.orderTotal.lkrString
    }
    
}
