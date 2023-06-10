//
//  HomeViewModel.swift
//  Parking
//
//  Created by Erzhan Taipov on 10.06.2023.
//

import UIKit
import CoreLocation
import YandexMapsMobile

protocol HomeViewModelInput: NSObject {
    func startSetupLocation()
}

struct ParkingModel {
//    let name: String?
    let address: String?
//    let capacity: Int?
//    let price: Int?
    let lat: String?
    let lon: String?
}

final class HomeViewModel: NSObject {
    
    private let dataManager: DataManager
    var locationManager: CLLocationManager
    var nearestAddressesArray: Observer<[ParkingModel]?> = Observer(value: [])
    var isUpdateUserLocation = false
    var mapCenter: Observer<YMKPoint?> = Observer(value: nil)
    
    init(locationManager: CLLocationManager = CLLocationManager(), dataManager: DataManager = DataManager()) {
        self.locationManager = locationManager
        self.dataManager = dataManager
    }
    
    func setupArray() {
        dataManager.getParkingArea { [weak self] value in
            guard let self else { return }
            guard let value else { return }
            self.nearestAddressesArray.value?.append(value)
        }
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            print("access missing")
        default:
            break
        }
    }
}

extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if isUpdateUserLocation == false {
            manager.stopUpdatingLocation()
            mapCenter.value = YMKPoint(latitude: locValue.latitude, longitude: locValue.longitude)
            setupArray()
//            callingNearestPunkts(latitude: String(locValue.latitude), longitude: String(locValue.longitude))
            isUpdateUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("<==== LOCATION ERROR - \(error) ======>")
    }
}

extension HomeViewModel: HomeViewModelInput {
    func startSetupLocation() {
        configureLocationManager()
    }
}
