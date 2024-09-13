//
//  UITextField.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/09/2024.
//

import UIKit

public extension UITextField {
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setPlaceholderTextColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
    }
}
