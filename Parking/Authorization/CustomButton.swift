//
//  CustomButton.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import UIKit

final class CustomButton: UIButton {
    
    var title: String
    
    init(title : String) {
        self.title = title
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
        backgroundColor = UIColor.systemBlue
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
           let activityIndicator = UIActivityIndicatorView()
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           activityIndicator.color = .black
           addSubview(activityIndicator)
           NSLayoutConstraint.activate([
               activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
               activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
           ])
           return activityIndicator
       }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loading(_ isLoading: Bool) {
        isEnabled = !isLoading
        if isLoading {
//            setTitle("", for: .normal)
            titleLabel?.alpha = 0
            activityIndicator.startAnimating()
        } else {
//            setTitle(title, for: .normal)
            activityIndicator.stopAnimating()
            titleLabel?.alpha = 1
        }
    }
}

