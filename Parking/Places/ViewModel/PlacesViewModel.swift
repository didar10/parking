//
//  PlacesViewModel.swift
//  Parking
//
//  Created by Erzhan Taipov on 13.06.2023.
//

import UIKit

final class PlacesViewModel: NSObject {
    
    private let dataManager: DataManager
    
    var placesArray: Observer<[ParkingSpace]?> = Observer(value: [])
    
//    var carDetail: Observer<CarDetail?> = Observer(value: nil)
    
    var fromTime = ""
    var toTime = ""
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func setUpPlaces() {
        dataManager.getParkingSpaces { [weak self] result in
            guard let self else { return }
            self.placesArray.value = result
        }
    }
    
    func getCarInfo() -> CarDetail? {
        var car: CarDetail?
        dataManager.getCarDetail { [weak self] detail in
            guard let self else { return }
            car = detail
        }
        return car
    }
    
    func passFromTime(time: String) {
        fromTime = time
    }
    
    func passToTime(time: String) {
        toTime = time
    }
    
    func checkDetails() -> Bool? {
//        if !fromTime.isEmpty && !toTime.isEmpty {
            if let _ = getCarInfo() {
                return true
            } else {
                return false
            }
//        }
//        return false
    }
}
