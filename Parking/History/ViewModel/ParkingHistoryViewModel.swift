//
//  ParkingHistoryViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 13.06.2023.
//

import Foundation

final class ParkingHistoryViewModel {
    var history: [ParkingHistory] = []
    var bindHistory: (() -> ()) = {}
    
    let dataManager: DataManager
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getHistory() {
        dataManager.getParkingHistory { [weak self] data in
            guard let self else { return }
            if let data {
                self.history = data
                self.bindHistory()
            } else {
                self.history = []
                self.bindHistory()
            }
        }
//        history = [
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 12B",
//            parkingTime: "Время: 15:00 - 17:16"),
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 1B",
//            parkingTime: "Время: 13:16 - 17:16"),
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 13A",
//            parkingTime: "Время: 14:16 - 17:16"),
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 22C",
//            parkingTime: "Время: 16:16 - 17:16"),
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 1D",
//            parkingTime: "Время: 12:16 - 17:16"),
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 12H",
//            parkingTime: "Время: 05:16 - 17:16"),
//            ParkingHistory(
//            parkingName: "Твоя парковка мечты",
//            parkingSpaceNumber: "Место: 5B",
//            parkingTime: "Время: 01:16 - 17:16")
//        ]
//        bindHistory()
    }
}
