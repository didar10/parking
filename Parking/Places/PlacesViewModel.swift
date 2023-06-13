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
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func setUpPlaces() {
        dataManager.getParkingSpaces { [weak self] result in
            guard let self else { return }
            self.placesArray.value = result
        }
    }
    
}
