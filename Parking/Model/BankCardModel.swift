//
//  BankCardModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import Foundation

enum PaymentSystem {
    case paybox
    case cloudPayment
}

struct BankCardModel: Decodable {
    let id: Int?
    let number: String?
    let dateExp: String?
    let type: Int?
    let isDefault: Bool?
}
