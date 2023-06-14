//
//  BaseUICollectionViewCell.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import UIKit

class BaseUICollectionViewCell: UICollectionViewCell {
    
    lazy var sizeScreen: CGFloat = UIScreen.main.bounds.height
    lazy var height: CGFloat = UIScreen.main.bounds.height
    lazy var width: CGFloat = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .clear
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
    
    func box() -> CGFloat {
        
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
}
