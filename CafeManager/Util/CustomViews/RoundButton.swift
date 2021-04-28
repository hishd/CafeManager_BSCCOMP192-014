//
//  RoundButton.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-27.
//

import UIKit

extension UIButton {
    func generateRoundButton() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
