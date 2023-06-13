//
//  PlaceCell.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import UIKit

final class PlaceCell: UICollectionViewCell {
    override class func description() -> String {
        return "PlaceCell"
    }
    let seatNumberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.layer.cornerRadius = 5
        seatNumberLabel.font = UIFont.systemFont(ofSize: 15)
        seatNumberLabel.textAlignment = .center
        seatNumberLabel.textColor = UIColor.darkGray
        contentView.addSubview(seatNumberLabel)
        seatNumberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func generateCells(_ model: ParkingSpace) {
        if let isAvailable = model.isAvailable {
            if isAvailable {
                contentView.backgroundColor = .systemGreen
            } else {
                contentView.backgroundColor = .red
            }
        }
        seatNumberLabel.text = model.number
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
