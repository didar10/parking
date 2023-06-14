//
//  PaymentPageViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import Foundation

struct StaticItems {
    static var saveDataSuccessCallBack: (() -> ()) = {}
    static var changeTabbarItemCallBack: (() -> ()) = {}
}

protocol PaymentPageViewModelOutput: AnyObject {
    func saveParkingHistorySuccess()
    func saveParkingHistoryFailure()
}

final class PaymentPageViewModel {
    private let dataManager: DataManager
    weak var viewModelOutput: PaymentPageViewModelOutput?
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func saveParking() {
        let model = ParkingHistory(
            parkingName: OrderItems.name,
            parkingSpaceNumber: OrderItems.space,
            parkingTime: OrderItems.time)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self else { return }
            
            self.dataManager.changeParkingSpace(number: OrderItems.space) { isSuccess in
                if isSuccess {
                    self.dataManager.saveParkingHistory(data: model) { isSuccess, error in
                        if isSuccess {
                            DispatchQueue.main.async {
                                self.viewModelOutput?.saveParkingHistorySuccess()
                            }
                        }
                        
                        if let error {
                            print(error)
                            self.viewModelOutput?.saveParkingHistoryFailure()
                        }
                    }
                } else {
                    self.viewModelOutput?.saveParkingHistoryFailure()
                }
            }
            
        }
    }
}
