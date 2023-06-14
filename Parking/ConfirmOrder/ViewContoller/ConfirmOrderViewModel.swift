//
//  ConfirmOrderViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import Foundation

final class ConfirmOrderViewModel: NSObject {
    var dataManager: DataManager
    
    var car: Observer<CarDetail?> = Observer(value: nil)
    
    var cards: Observer<[PaymentMethodDataViewModel]> = Observer(value: [])
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getCarInfo() {
        dataManager.getCarDetail { [weak self] detail in
            guard let self else { return }
            self.car.value = detail
        }
    }
}
