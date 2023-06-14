//
//  UIViewController + Extension.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import UIKit

extension UIViewController {
    func setAlertView(text: String, time: Double) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + time
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismissByFade(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        if let window = view.window {
            window.layer.backgroundColor = UIColor.white.cgColor
            window.layer.add(transition, forKey: kCATransition)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func presentByFade(controller: UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        if let window = view.window {
            window.layer.backgroundColor = UIColor.white.cgColor
            window.layer.add(transition, forKey: kCATransition)
        }
        present(controller, animated: false, completion: nil)
    }
    
    func navigationBar(isHidden: Bool){
        navigationController?.navigationBar.isHidden = isHidden
    }
    
    func navigationBarSwipeGesture(isEnabled: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
}
