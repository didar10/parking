//
//  ProfileViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import Foundation

protocol ProfileViewModelOutput: AnyObject {
    func logOutSuccess()
    func logOutFailure(error: String)
}

final class ProfileViewModel {
    private let dataManager: DataManager
    weak var viewModelOutput: ProfileViewModelOutput?
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func logOut() {
        dataManager.logOut { [weak self] isSuccess, error in
            guard let self else { return }
            if isSuccess {
                self.viewModelOutput?.logOutSuccess()
            } else {
                self.viewModelOutput?.logOutFailure(error: error ?? "")
            }
        }
    }
}
