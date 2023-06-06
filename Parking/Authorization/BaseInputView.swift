//
//  BaseInputView.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import UIKit
import SnapKit

class BaseInputView: BaseUIView {
    let containerView = UIView()
    let titleLabel = UILabel()
    let textField = CustomTextField(padding: 16.0)
    
    let errorLabel = UILabel()
    lazy var stackView = UIStackView(arrangedSubviews: [containerView])
    
    var shimmeringAnimatedItems: [UIView] {
        [
            containerView
        ]
    }
    
    override func configureViews() {
        super.configureViews()
        self.layer.cornerRadius = 16
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .black
        errorLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        errorLabel.textColor = .red
        errorLabel.textAlignment = .left
        stackView.axis = .vertical
        stackView.spacing = 8
    }
    
    override func setupViews() {
        super.setupViews()
        [titleLabel, textField].forEach { view in
            containerView.addSubview(view)
        }
        addSubview(stackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        containerView.snp.makeConstraints{
            $0.height.equalTo(65)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
        }
        
        textField.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(39)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

