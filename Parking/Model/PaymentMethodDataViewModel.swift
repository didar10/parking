//
//  PaymentMethodDataViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import Foundation

final class PaymentMethodDataViewModel: NSObject {
    var data: BankCardModel
    var type: PaymentSystem
    var isSelected: Bool = false
    
    public init(data: BankCardModel, type: PaymentSystem) {
        self.data = data
        self.type = type
    }
    
    var title: String? {
        return getTitle()
    }
    
    var id: Int? {
        return getId()
    }
    
    var iconImage: UIImage? {
        return UIImage(named: "PaymentMethod")
    }
    
    var number: String? {
        return getNumber()
    }
    
    func getId() -> Int? {
        if let id = data.id {
            return id
        }
        return nil
    }
    
    func getNumber() -> String? {
        return data.number
    }
    
    func getTitle() -> String? {
        if let cardNumber = data.number {
            return "****\(cardNumber.suffix(4))"
        }
        
        return nil
    }
}
