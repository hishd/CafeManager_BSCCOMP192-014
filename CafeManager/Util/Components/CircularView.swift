//
//  CircularView.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import Foundation
import UIKit

extension UIView {
    func generateRoundView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
