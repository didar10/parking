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
    
    private func checkFields() -> Bool {
        if fullName.isEmpty {
            viewModelOutput?.registrationFailure(error: "Введите пожалуйста полное имя")
            return false
        }
        
        if phone.isEmpty {
            viewModelOutput?.registrationFailure(error: "Введите пожалуйста телефонный номер")
            return false
        }
        
        if email.isEmpty {
            viewModelOutput?.registrationFailure(error: "Введите пожалуйста email")
            return false
        }
        
        if password.isEmpty {
            viewModelOutput?.registrationFailure(error: "Введите пожалуйста пароль")
            return false
        }
        
        return true
    }
    
    func handleRegistration() {
        if checkFields() {
            dataManager.createUser(email: email, password: password) { [weak self] isSuccess, error in
                guard let self else { return }
                if isSuccess {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.7) {
                        self.dataManager.saveUserData(fio: self.fullName, phone: self.phone, email: self.email) { isSuccess, error in
                            if isSuccess {
                                self.viewModelOutput?.registrationSuccess()
                            } else {
                                self.viewModelOutput?.registrationFailure(error: error ?? "")
                            }
                        }
                    }
                } else {
                    self.viewModelOutput?.registrationFailure(error: error ?? "")
                }
            }
        }
    }
}
