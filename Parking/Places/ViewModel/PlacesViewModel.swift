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
    
    var car: Observer<CarDetail?> = Observer(value: nil)
    
//    var car: CarDetail?
    
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
    
    func getCarInfo() {
        dataManager.getCarDetail { [weak self] detail in
            guard let self else { return }
            self.car.value = detail
        }
    }
    
    func passFromTime(time: String) {
        fromTime = time
    }
    
    func passToTime(time: String) {
        toTime = time
    }

//    func checkDetails() -> Bool? {
//        if let _ = car?.value.number {
//            return true
//        }
//        return true
//    }
}
