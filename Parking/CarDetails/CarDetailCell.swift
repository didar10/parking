//
//  CarDetailCell.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import UIKit

final class CarDetailCell: BaseUITableViewCell {
    override class func description() -> String {
        return "CarDetailCell"
    }
    
    let titleLabel = UILabel()
    let numberInputView = BaseInputView()
    let colorInputView = BaseInputView()
    let yearInputView = BaseInputView()
    let brandInputView = BaseInputView()
    let modelInputView = BaseInputView()
    let mainButton = CustomButton(title: "Сохранить")
    
    override func setupViews() {
        super.setupViews()
        setupUI()
    }
    
    func generateCell(_ carDetail: CarDetail) {
        numberInputView.textField.text = carDetail.number
        colorInputView.textField.text = carDetail.color
        yearInputView.textField.text = carDetail.year
        brandInputView.textField.text = carDetail.brand
        modelInputView.textField.text = carDetail.model
    }
}

extension CarDetailCell: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        [titleLabel, numberInputView, colorInputView, mainButton, yearInputView, brandInputView, modelInputView].forEach { subview in
            contentView.addSubview(subview)
        }
        setupConstraints()
    }
    
    func configureViews() {
        titleLabel.text = "Данные машины"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        numberInputView.titleLabel.text = "Номер машины"
        numberInputView.textField.newPlaceholder = "Номер машины"
        numberInputView.textField.keyboardType = .numberPad
        colorInputView.titleLabel.text = "Цвет"
        colorInputView.textField.newPlaceholder = "Цвет"
        yearInputView.titleLabel.text = "Год"
        yearInputView.textField.newPlaceholder = "Год"
        yearInputView.textField.keyboardType = .numberPad
        brandInputView.titleLabel.text = "Марка машины"
        brandInputView.textField.newPlaceholder = "Марка машины"
        modelInputView.titleLabel.text = "Модель машины"
        modelInputView.textField.newPlaceholder = "Модель машины"
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        numberInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        colorInputView.snp.makeConstraints { make in
            make.top.equalTo(numberInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        yearInputView.snp.makeConstraints { make in
            make.top.equalTo(colorInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        brandInputView.snp.makeConstraints { make in
            make.top.equalTo(yearInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        modelInputView.snp.makeConstraints { make in
            make.top.equalTo(brandInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(modelInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
    }
}
