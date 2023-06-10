//
//  CarDetailViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import Foundation

protocol CarDetailViewModelOutput: AnyObject {
    func saveCarDetailSuccess()
    func saveCarDetailFailure(error: String)
}

final class CarDetailViewModel {
    private let dataManager: DataManager
    var number: String = ""
    var color: String = ""
    var brand: String = ""
    var model: String = ""
    var year: String = ""
    var bindCarDetail: (() -> ()) = {}
    var carDetail: CarDetail?
    
    weak var viewModelOutput: CarDetailViewModelOutput?
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getCarDetail() {
        dataManager.getCarDetail { carDetail in
            if let carDetail {
                self.number = carDetail.number
                self.color = carDetail.color
                self.brand = carDetail.brand
                self.model = carDetail.model
                self.year = carDetail.year
                self.carDetail = carDetail
                self.bindCarDetail()
            }
        }
    }
    
    func saveCarDetail() {
        let model = CarDetail(number: number, color: color, brand: brand, model: model, year: year)
        dataManager.saveCarDetail(data: model) { isSuccess, error in
            if isSuccess {
                self.viewModelOutput?.saveCarDetailSuccess()
            } else {
                self.viewModelOutput?.saveCarDetailFailure(error: error ?? "")
            }
        }
    }
}
