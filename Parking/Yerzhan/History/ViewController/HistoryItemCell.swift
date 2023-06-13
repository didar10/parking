//
//  HistoryItemCell.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 13.06.2023.
//

import UIKit

final class HistoryItemCell: BaseUITableViewCell {
    override class func description() -> String {
        return "HistoryItemCell"
    }
    
    let containerView = UIView()
    let parkingNameLabel = UILabel()
    let parkingSpaceNumberLabel = UILabel()
    let parkingTimeLabel = UILabel()
    
    override func setupViews() {
        super.setupViews()
        setupUI()
    }
    
    func generateCell(_ data: ParkingHistory) {
        parkingNameLabel.text = data.parkingName
        parkingSpaceNumberLabel.text = data.parkingSpaceNumber
        parkingTimeLabel.text = data.parkingTime
    }
}

extension HistoryItemCell: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        contentView.addSubview(containerView)
        [parkingNameLabel, parkingTimeLabel, parkingSpaceNumberLabel].forEach { label in
            containerView.addSubview(label)
        }
        setupConstraints()
    }
    
    func configureViews() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemBlue.cgColor
        parkingSpaceNumberLabel.font = .systemFont(ofSize: 18, weight: .medium)
        parkingNameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        parkingTimeLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        parkingSpaceNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        parkingNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        parkingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(parkingNameLabel.snp.bottom).inset(-12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
