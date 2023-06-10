//
//  LoginViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import Foundation

protocol LoginViewModelOutput: AnyObject {
    func loginSuccess()
    func loginFailure(error: String)
}

final class LoginViewModel {
    private let dataManager: DataManager
    var email: String = ""
    var password: String = ""
    weak var viewModelOutput: LoginViewModelOutput?
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func handleLogin() {
        dataManager.signIn(email: email, password: password) { [weak self] isSuccess, error in
            guard let self else { return }
            if isSuccess {
                self.viewModelOutput?.loginSuccess()
            } else {
                self.viewModelOutput?.loginFailure(error: error ?? "")
            }
        }
    }
}
