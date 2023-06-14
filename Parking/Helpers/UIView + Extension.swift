//
//  UIView + Extension.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import UIKit

extension UIView {
    func onTapped(action: (() -> Void)?) {
        tapAction = action
        let selector = #selector(handleTap)
        let recognizer = UITapGestureRecognizer(target: self, action: selector)
        isUserInteractionEnabled = true
        addGestureRecognizer(recognizer)
    }
}

fileprivate extension UIView {
    typealias Action = (() -> Void)
    
    struct Key { static var id = "tapAction" }
    
    var tapAction: Action? {
        get {
            return objc_getAssociatedObject(self, &Key.id) as? Action
        }
        set {
            guard let value = newValue else { return }
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            objc_setAssociatedObject(self, &Key.id, value, policy)
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        tapAction?()
    }
}

