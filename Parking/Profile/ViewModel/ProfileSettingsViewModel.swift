//
//  ProfileSettingsViewModel.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import Foundation

final class ProfileSettingsViewModel {
    private let dataManager: DataManager
    var profile: Profile?
    var bindProfile: (() -> ()) = {}
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getProfile() {
        dataManager.getProfile { profile in
            self.profile = profile
            self.bindProfile()
        }
    }
}
