//
//  PaymentMethodCVCell.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

final class PaymentMethodCVCell: BaseUICollectionViewCell {
    override class func description() -> String {
        return "PaymentMethodCVCell"
    }
    
    let cardView = BaseCardView()
    let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    let titleLabel = UILabel()
    
    override func setupViews() {
        super.setupViews()
        configureViews()
        contentView.addSubview(cardView)
        [iconImageView, titleLabel].forEach { subview in
            cardView.addSubview(subview)
        }
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView.didUnSelect()
        titleLabel.textColor = UIColor.black
    }
    
    func generateCell(_ data: PaymentMethodDataViewModel) {
        iconImageView.image = UIImage(named: "PaymentMethod")
        titleLabel.text = data.title
        if data.isSelected {
            cardView.didSelect()
            titleLabel.textColor = UIColor.systemBlue
        } else {
            cardView.didUnSelect()
            titleLabel.textColor = UIColor.black
        }
    }
}

extension PaymentMethodCVCell: ConfigureCellUI {
    func configureViews() {
        iconImageView.layer.masksToBounds = true
        iconImageView.image = UIImage(named: "PaymentMethod")
        iconImageView.contentMode = .scaleAspectFill
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor.systemBlue
    }
    
    func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.height.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.leading.equalToSuperview().inset(44)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}
