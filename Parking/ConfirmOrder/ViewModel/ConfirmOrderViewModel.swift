//
//  ConfirmOrderViewModel.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

final class ConfirmOrderViewModel: NSObject {
    var dataManager: DataManager
    
    var car: Observer<CarDetail?> = Observer(value: nil)
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getCarInfo() {
        dataManager.getCarDetail { [weak self] detail in
            guard let self else { return }
            print("detail \(detail)")
            self.car.value = detail
        }
    }
}
