//
//  SpacedLabel.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-27.
//

import Foundation

import UIKit

extension UILabel {

    func addInterlineSpacing(spacingValue: CGFloat = 2, alignment: NSTextAlignment = .left) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        let attributedString = NSMutableAttributedString(string: textString)

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = spacingValue
        paragraphStyle.alignment = alignment

        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        attributedText = attributedString
    }

}
