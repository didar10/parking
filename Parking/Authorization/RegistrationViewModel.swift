//
//  RegistrationViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 07.06.2023.
//

import Foundation

final class RegistrationViewModel {
    var fullName: String = ""
    var phone: String = ""
    var email: String = ""
    var password: String = ""
    
    let dataManager: DataManager
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func handleRegistration() {
        print("START")
        dataManager.createUser(email: email, password: password)
    }
}
