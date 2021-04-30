//
//  BaseViewController.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import Foundation
import UIKit
import Loaf
import NotificationBannerSwift
import CoreLocation
import ProgressHUD

class BaseViewController : UIViewController {
    var networkMonitor = NetworkMonitor.instance
    var alertController: UIAlertController!
    var firebaseOP = FirebaseOP.instance
    let refreshControl = UIRefreshControl()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.colorAnimation = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        ProgressHUD.colorStatus = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    func displayProgress() {
        ProgressHUD.show("Please wait!")
    }
    
    func dismissProgress() {
        ProgressHUD.dismiss()
    }
    
    func displayErrorMessage(message: String, completion: (() -> Void)?) {
        
        guard let completionHandler = completion else {
            displayBanner(type: .ERROR, body: message)
            return
        }
        
        Loaf(message, state: .error, sender: self).show(.custom(2.0)) {
            dismissal in
            completionHandler()
        }
    }
    
    func displaySuccessMessage(message: String, completion: (() -> Void)?) {
        
        guard let completionHandler = completion else {
            displayBanner(type: .SUCCESS, body: message)
            return
        }
        
        Loaf(message, state: .success, sender: self).show(.custom(2.0)) {
            dismissal in
            completionHandler()
        }
    }
    
    func displayInfoMessage(message: String, completion: (() -> Void)?) {
        
        guard let completionHandler = completion else {
            displayBanner(type: .INFO, body: message)
            return
        }
        
        Loaf(message, state: .info, sender: self).show(.custom(2.0)) {
            dismissal in
            completionHandler()
        }
    }
    
    func displayWarningMessage(message: String, completion: (() -> Void)?) {
        
        guard let completionHandler = completion else {
            displayBanner(type: .WARNING, body: message)
            return
        }
        
        Loaf(message, state: .warning, sender: self).show(.custom(2.0)) {
            dismissal in
            completionHandler()
        }
    }
    
    func displayProgressBanner() {
        GrowingNotificationBanner(title: "NIBM Cafe", subtitle: "Please wait", style: .info).show()
    }
    
    fileprivate func displayBanner(type: BANNER_TYPE, body: String) {
        switch type {
            case .SUCCESS:
                let successBanner = GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .success)
                successBanner.duration = 1.5
                successBanner.show()
//                GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .success).show()
            case .WARNING:
                let warningBanner = GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .warning)
                warningBanner.duration = 1.5
                warningBanner.show()
//                GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .warning).show()
            case .INFO:
                let infoBanner = GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .info)
                infoBanner.duration = 1.5
                infoBanner.show()
//                GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .info).show()
            case .ERROR:
                let errorBanner = GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .danger)
                errorBanner.duration = 1.5
                errorBanner.show()
//                GrowingNotificationBanner(title: "NIBM Cafe", subtitle: body, style: .danger).show()
        }
    }
    
    func displayActionSheet(title: String, message: String, actionTitle1: String, actionTitle2: String, actionHandler1: @escaping (UIAlertAction) -> Void, actionHandler2: @escaping (UIAlertAction) -> Void) {
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alertController.title = title
        alertController.message = message
        alertController.addAction(UIAlertAction(title: actionTitle1, style: .destructive, handler: actionHandler1))
        alertController.addAction(UIAlertAction(title: actionTitle2, style: .default, handler: actionHandler2))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayActionSheet(title: String, message: String, positiveTitle: String, negativeTitle: String, positiveHandler: @escaping (UIAlertAction) -> Void) {

        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alertController.title = title
        alertController.message = message
        alertController.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: positiveHandler))
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    enum BANNER_TYPE {
        case SUCCESS
        case WARNING
        case INFO
        case ERROR
    }
}
