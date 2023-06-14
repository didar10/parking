//
//  CardInputView.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import UIKit

protocol CardInputViewDelegate: AnyObject {
    func getCardNumber(text: String?)
    func getExperationDate(text: String?)
    func getCardHolderName(text: String?)
}

final class CardInputView: BaseUIView {
    let cardTitleLabel = UILabel()
    let cardIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 36))
    
    let numberCardView = UIView()
    let numberLabel = UILabel()
    let numberTextField = CustomTextField(padding: 0)
    let scanButton = UIButton(type: .system)
    lazy var numberStackView = UIStackView(arrangedSubviews: [numberLabel, numberTextField])
    
    let expirationCardView = UIView()
    let expirationLabel = UILabel()
    let expirationTextField = CustomTextField(padding: 0)
    lazy var expirationStackView = UIStackView(arrangedSubviews: [expirationLabel, expirationTextField])
    
    let codeCardView = UIView()
    let codeLabel = UILabel()
    let codeTextField = CustomTextField(padding: 0)
    lazy var codeStackView = UIStackView(arrangedSubviews: [codeLabel, codeTextField])
    
    lazy var cardStackView = UIStackView(arrangedSubviews: [expirationCardView, codeCardView])
    
    let nameCardView = UIView()
    let nameLabel = UILabel()
    let nameTextField = CustomTextField(padding: 0)
    lazy var nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])

    override func setupViews() {
        super.setupViews()
        [cardTitleLabel, numberCardView, cardStackView, nameCardView].forEach { v in
            addSubview(v)
        }
        
        [numberStackView, scanButton].forEach { v in
            numberCardView.addSubview(v)
        }
        
        expirationCardView.addSubview(expirationStackView)
        codeCardView.addSubview(codeStackView)
        nameCardView.addSubview(nameStackView)
    }
    
    override func configureViews() {
        super.configureViews()
        layer.cornerRadius = 14
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
        
        cardTitleLabel.textColor = .black
        cardTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cardTitleLabel.text = "DEBIT / CREDIT"
        
        [numberCardView, codeCardView, expirationCardView, nameCardView].forEach { v in
            v.layer.cornerRadius = 14
            v.layer.borderColor = UIColor.systemBlue.cgColor
            v.layer.borderWidth = 1
        }
        
        [numberLabel, expirationLabel, codeLabel, nameLabel].forEach { l in
            l.textColor = .black
            l.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        }
        
        numberLabel.text = "Номер Карты"
        expirationLabel.text = "Срок Действия"
        codeLabel.text = "Код безапасности"
        nameLabel.text = "Имя на карте"
        
        [numberTextField, expirationTextField, codeTextField].forEach { t in
            t.keyboardType = .numberPad
        }
        
        nameTextField.autocapitalizationType = .allCharacters
        
        numberTextField.newPlaceholder = "0000 0000 0000 0000"
        expirationTextField.newPlaceholder = "MM/YY"
        codeTextField.newPlaceholder = "000"
        nameTextField.newPlaceholder = "Имя на карте"
        
        [numberStackView, expirationStackView, codeStackView, nameStackView].forEach { s in
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.spacing = 8
        }
        
        cardStackView.axis = .horizontal
        cardStackView.distribution = .fillEqually
        cardStackView.spacing = 12
        
        cardIconImageView.contentMode = .scaleAspectFill
    }
    
    func changeCardHeader() {
        cardTitleLabel.removeFromSuperview()
        cardTitleLabel.text = nil
        addSubview(cardIconImageView)
        cardIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(36)
            make.width.equalTo(40)
        }
        
        numberCardView.snp.remakeConstraints { make in
            make.top.equalTo(cardIconImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        [numberTextField, expirationTextField, codeTextField, nameTextField].forEach { v in
            v.snp.remakeConstraints { make in
                make.height.equalTo(20)
            }
        }
        
        numberStackView.snp.remakeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(50)
        }
        
        scanButton.snp.remakeConstraints { make in
            make.centerY.equalTo(numberStackView)
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(32)
        }
        
        cardStackView.snp.remakeConstraints { make in
            make.top.equalTo(numberCardView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        nameCardView.snp.remakeConstraints { make in
            make.top.equalTo(cardStackView.snp.bottom).inset(-12)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        nameStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        expirationStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        codeStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(12)
        }
        
        numberCardView.snp.makeConstraints { make in
            make.top.equalTo(cardTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        [numberTextField, expirationTextField, codeTextField, nameTextField].forEach { v in
            v.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
        
        numberStackView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(50)
        }
        
        scanButton.snp.makeConstraints { make in
            make.centerY.equalTo(numberStackView)
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(32)
        }
        
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(numberCardView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        nameCardView.snp.makeConstraints { make in
            make.top.equalTo(cardStackView.snp.bottom).inset(-12)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        expirationStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        codeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
}
