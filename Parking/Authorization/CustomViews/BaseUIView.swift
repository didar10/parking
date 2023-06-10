//
//  BaseUIView.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import UIKit

class BaseUIView: UIView {
    
    var sizeScreen: CGFloat = UIScreen.main.bounds.height
    lazy var small = sizeScreen < 736 ? 8 : 12
    var height: CGFloat = UIScreen.main.bounds.height
    var width: CGFloat = UIScreen.main.bounds.width
    lazy var y = sizeScreen < 736 ? 14 : 16

    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .whiteLarge
            // Fallback on earlier versions
        }
        indicator.color = .black
            
        // The indicator should be animating when
        // the view appears.
        indicator.startAnimating()
            
        // Setting the autoresizing mask to flexible for all
        // directions will keep the indicator in the center
        // of the view and properly handle rotation.
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
            
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        
        // Setting the autoresizing mask to flexible for
        // width and height will ensure the blurEffectView
        // is the same size as its parent view.
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews(){
    }
    
    func setupViews(){
    }
    
    func setupConstraints(){
    }
    
    func boxCell() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 54
        }
        
        if (height > 790 && width > 400) {
            return 60
        }
        
        else {
            return 56
        }
    }
    
    func fontMedium() -> Float {
        
        if (height > 740 && width < 400) {
            return 14
        }
        
        if (height > 790 && width > 400) {
            return 16
        }
        
        else {
            return 16
        }
    }
    
    func fontBig() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 20
        }
        
        if (height > 790 && width > 400) {
            return 24
        }
        
        else {
            return 20
        }
    }
    
    func medium() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 44
        }
        
        if (height > 790 && width > 400) {
            return 52
        }
        
        else {
            return 48
        }
        
    }
    
    func big() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 48
        }
        
        if (height > 790 && width > 400) {
            return 60
        }
        
        else {
            return 52
        }
        
    }
    
    func showLoadingIndicator() {
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // Add the blurEffectView with the same
        // size as view
        blurEffectView.frame = self.bounds
        addSubview(blurEffectView)
//        insertSubview(blurEffectView, at: 0)
        
        // Add the loadingActivityIndicator in the
        // center of view
        loadingActivityIndicator.center = CGPoint(
            x: bounds.midX,
            y: bounds.midY
        )
        addSubview(loadingActivityIndicator)
    }
    
    func hideLoadingIndicator() {
        backgroundColor = .white
        blurEffectView.removeFromSuperview()
        loadingActivityIndicator.removeFromSuperview()
    }
}

