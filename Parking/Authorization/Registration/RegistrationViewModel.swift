//
//  RegistrationViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 07.06.2023.
//

import Foundation

protocol RegistrationViewModelOutput: AnyObject {
    func registrationSuccess()
    func registrationFailure(error: String)
}

final class RegistrationViewModel {
    var fullName: String = ""
    var phone: String = ""
    var email: String = ""
    var password: String = ""
    weak var viewModelOutput: RegistrationViewModelOutput?
    
    let dataManager: DataManager
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func handleRegistration() {
        dataManager.createUser(email: email, password: password) { [weak self] isSuccess, error in
            guard let self else { return }
            if isSuccess {
                self.viewModelOutput?.registrationSuccess()
            } else {
                self.viewModelOutput?.registrationFailure(error: error ?? "")
            }
        }
    }
}
