//
//  CustomSecondaryButton.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import UIKit

class CustomSecondaryButton : UIButton {
    var title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.systemBlue, for: .normal)
        setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
