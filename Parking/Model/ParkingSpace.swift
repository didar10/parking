//
//  ParkingSpace.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import Foundation

struct ParkingSpace {
    let fromDate: String?
    let isAvailable: Bool?
    let number: String?
    let toDate: String?
}

struct ParkingModel: Codable, Equatable {
    let address: String?
    let lat: String?
    let lon: String?
}
