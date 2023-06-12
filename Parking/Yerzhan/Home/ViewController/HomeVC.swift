//
//  HomeVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 06.06.2023.
//

import UIKit
import YandexMapsMobile

class HomeVC: UIViewController {
    
    var mapView: YMKMapView?
    
    var mapCenter: YMKPoint?
    
    var homePointObjectsCollection: YMKMapObjectCollection!
    
    var imageProvider = UIImage(named: "NewClinicPin")

    let mapAnimation = YMKAnimation(
        type: YMKAnimationType.smooth, duration: 0.8)
    
    var viewModel = HomeViewModel()
    
    let zoomInButton = UIButton(type: .custom)
    let zoomOutButton = UIButton(type: .custom)
    let currentLocationButton = UIButton(type: .custom)
    
    var gcpointsPlmCollection: YMKClusterizedPlacemarkCollection!
    
    var lastPlacemark: YMKPlacemarkMapObject?
    
    lazy var buttonsStack = UIStackView(arrangedSubviews: [zoomInButton, zoomOutButton, currentLocationButton])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModel()
        setupUI()
    }
    
    func callToViewModel() {
        viewModel.configureLocationManager()
        viewModel.mapCenter.bind { [weak self] value in
            guard let self else { return }
            guard let value else { return }
            self.setupMapCenter(mapCenter: value)
        }
        
        viewModel.nearestAddressesArray.bind { [weak self] value in
            guard let self else { return }
            guard let value else { return }
            self.setupAfter(address: value)
        }
    }
    
    func setupMapCenter(mapCenter: YMKPoint) {
        self.mapCenter = mapCenter
        moveMapAfterUpdateLocation(center: mapCenter, zoom: 17)
//        setupHomePointOnMap(mapObjectCollection: homePointObjectsCollection)
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
    
    func setupAfter(address: [ParkingModel]) {
        for i in address{
            let latD = Double(i.lat!)
            let lonD = Double(i.lon!)
            let Ypoint = YMKPoint(latitude: latD!, longitude: lonD!)
            let placemark = gcpointsPlmCollection.addPlacemark(
                with: Ypoint, image: imageProvider!, style: YMKIconStyle())
            placemark.userData = i
            placemark.addTapListener(with: self)
            gcpointsPlmCollection.clusterPlacemarks(
                withClusterRadius: 60, minZoom: 15)
        }
    }
    
    private func setupMapView() {
        guard let mapView = mapView else { return }
        homePointObjectsCollection = getMapObjectCollection()
        gcpointsPlmCollection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        gcpointsPlmCollection.addTapListener(with: self)
        if let value = viewModel.nearestAddressesArray.value{
            setupAfter(address: value)
        }
    }
    
    func getMapObjectCollection() -> YMKMapObjectCollection {
        return mapView!.mapWindow.map.mapObjects.add()
    }
    
    func zoomPlus(zoom: Float){
        if let mapView = mapView {
            let map = mapView.mapWindow.map
            let target =  map.cameraPosition.target
            let position = YMKCameraPosition(target: target, zoom: map.cameraPosition.zoom + zoom, azimuth: 0, tilt: 0)
            map.move(with: position, animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.3), cameraCallback: nil)
        }
    }
    
    func zoomMinus(zoom: Float){
        if let mapView = mapView {
            let map = mapView.mapWindow.map
            let target =  map.cameraPosition.target
            let position = YMKCameraPosition(target: target, zoom: map.cameraPosition.zoom - zoom, azimuth: 0, tilt: 0)
            map.move(with: position, animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.3), cameraCallback: nil)
        }
    }
    
    @objc private func zoomPlusMapHandled() {
        zoomPlus(zoom: 0.5)
    }
    
    @objc private func zoomLongPressHandled() {
        zoomPlus(zoom: 0.5)
    }
    
    @objc private func zoomMinusMapHandled() {
        zoomMinus(zoom: 0.5)
    }
    
    @objc private func goBackToInitialLocation() {
        if let mapCenter = mapCenter {
            currentLocationButton.setImage(UIImage(named: "NewLocationButtonSelected"), for: .selected)
            moveMapAfterUpdateLocation(center: mapCenter, zoom: 15)
        }
    }
}

extension HomeVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        mapView = YMKMapView()
        if let mapView = mapView {
            view.addSubview(mapView)
            mapView.addSubview(buttonsStack)
        }
        setupMapView()
        addActionsForUIElements()
        configureViews()
        setupConstraints()
    }
    
    func configureViews() {
        [zoomInButton, zoomOutButton, currentLocationButton].forEach { button in
            button.backgroundColor = .white
            button.layer.borderColor =  UIColor.systemGray.cgColor
            button.layer.borderWidth = 1
            button.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
            button.widthAnchor.constraint(equalToConstant: 56).isActive = true
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
            button.layer.cornerRadius = 28
            button.clipsToBounds = true
            button.layer.masksToBounds = true
        }
        
        zoomInButton.setImage(UIImage(named: "New+"), for: .normal)
        zoomOutButton.setImage(UIImage(named: "New-"), for: .normal)
        currentLocationButton.setImage(UIImage(named: "NewLocationButtonImage"), for: .normal)
        currentLocationButton.setImage(UIImage(named: "NewLocationButtonSelected"), for: .selected)
        
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .equalSpacing
        buttonsStack.spacing = 12
    }
    
    func addActionsForUIElements() {
        zoomInButton.addTarget(
            self, action: #selector(zoomPlusMapHandled),
            for: .touchUpInside)
        zoomOutButton.addTarget(
            self, action: #selector(zoomMinusMapHandled),
            for: .touchUpInside)
        currentLocationButton.addTarget(
            self, action: #selector(goBackToInitialLocation),
            for: .touchUpInside)
    }
    
    
    func setupConstraints() {
        mapView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(236)
            make.width.equalTo(56)
            make.height.equalTo(204)
        }
    }
}

extension HomeVC: YMKClusterListener, YMKClusterTapListener, YMKMapObjectTapListener {
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateReason: YMKCameraUpdateReason,
                                 finished: Bool) {
//        mainVew.currentLocationButton.setImage(ImageConstants.MapImages.goToCurrentLocation, for: .normal)
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        moveMapAfterUpdateLocation(center: point, zoom: 17)
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false}
//
//        placemark.setIconWith(UIImage(named: "NewClosestClinicPin")!) {
////            self.scrolling?(false)
////
//            if let lastPlacemark = self.lastPlacemark {
//                lastPlacemark.setIconWith(self .imageProvider!)
//            }
////
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.lastPlacemark = placemark
//            }
//        }
        if let userData = placemark.userData as? ParkingModel {
            if let array = viewModel.nearestAddressesArray.value {
                if let p = array.firstIndex(where: { $0 == userData }) {
                    let vc = PlacesVC()
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }

        return true
    }
       
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(cluster.clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }
  
    func onClusterTap(with cluster: YMKCluster) -> Bool {
//        let map = mainView.mapView!
//        let latitude = cluster.appearance.geometry.latitude
//        let longitude = cluster.appearance.geometry.longitude
//        let zoom = map.mapWindow.map.cameraPosition.zoom + 4
//        let movePoint = YMKPoint(latitude: latitude, longitude: longitude)
//        mainView.moveMapAfterUpdateLocation(center: movePoint, zoom: zoom)
        return true
    }
}
