//
//  HomeVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 06.06.2023.
//

import UIKit
import YandexMapsMobile

class HomeVC: UIViewController {

//    static let YANDEX_MAP_KEY = "c3872c0a-711c-484b-aa06-d321c8a89858"
    
//    YMKMapKit.setApiKey("c3872c0a-711c-484b-aa06-d321c8a89858")
//    YMKMapKit.setLocale("ru_RU")
//    YMKMapKit.sharedInstance()
    
    var mapView: YMKMapView?
    
    var mapCenter: YMKPoint?
    
    var homePointObjectsCollection: YMKMapObjectCollection!
    
//    var imageProvider = ImageConstants.MapImages.labPin
//
//    var homeImage = ImageConstants.MapImages.labPin
    let mapAnimation = YMKAnimation(
        type: YMKAnimationType.smooth, duration: 0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        mapView = YMKMapView()
        if let mapView = mapView {
            view.addSubview(mapView)
        }
        
        mapView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func setupMapCenter(mapCenter: YMKPoint) {
        self.mapCenter = mapCenter
//        moveMapAfterUpdateLocation(center: mapCenter, zoom: 17)
        setupHomePointOnMap(mapObjectCollection: homePointObjectsCollection)
    }
    
    func setupHomePointOnMap(mapObjectCollection: YMKMapObjectCollection) {
        if let center = mapCenter {
            mapObjectCollection.addPlacemark(with: center, image: UIImage(named: "newProfileSelected")!, style: YMKIconStyle())
        }
    }
    
    func moveMapAfterUpdateLocation(center: YMKPoint, zoom: Float) {
        let cameraPosition = YMKCameraPosition(
            target: center, zoom: zoom, azimuth: 0, tilt: 0)
        if let mapView = self.mapView {
            mapView.mapWindow.map.move(
            with: cameraPosition, animationType: self.mapAnimation)
        }
    }
}
