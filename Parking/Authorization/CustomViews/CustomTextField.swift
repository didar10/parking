//
//  CustomTextField.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    let padding : CGFloat
    
    var textfieldText = String()
    
    var newPlaceholder: String? {
        didSet {
            setupAttributedPlaceholder()
        }
    }
    
    init(padding : CGFloat) {
        self.padding = padding
        super.init(frame : .zero)
        self.textColor = .black
    }
    
    private func setupAttributedPlaceholder() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        
        if let newPlaceholder = newPlaceholder {
            self.attributedPlaceholder = NSAttributedString(
                string: newPlaceholder,
                attributes: attributes
            )
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
        
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 48)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

