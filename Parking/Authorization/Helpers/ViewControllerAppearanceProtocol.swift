//
//  ViewControllerAppearanceProtocol.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import UIKit
import YandexMapsMobile

protocol ViewControllerAppearanceProtocol {
    func setupUI()
    func configureViews()
    func setupConstraints()
    func setupTableView()
    func setupCollectionView()
    func registerTableViewCells()
    func registerCollectionViewCells()
    func addGesturesForUIElements()
    func removeGesturesFromUIElements()
    func setupDelegates()
    func setupBottomSheet()
    func addActionsForUIElements()
    func configureNavigationController()
}

extension ViewControllerAppearanceProtocol {
    func configureViews() {}
    func setupConstraints() {}
    func setupTableView() {}
    func setupCollectionView() {}
    func registerTableViewCells() {}
    func registerCollectionViewCells() {}
    func addGesturesForUIElements() {}
    func removeGesturesFromUIElements() {}
    func setupDelegates() {}
    func setupBottomSheet() {}
    func addActionsForUIElements() {}
    func configureNavigationController() {}
}

let PLACEMARKS_NUMBER = 3
let FONT_SIZE: CGFloat = 15
let MARGIN_SIZE: CGFloat = 3
let STROKE_SIZE: CGFloat = 3

extension YMKCluster {
    
    func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
//        ctx.setFillColor(CustomColors.mainDeepBlue.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
//        ctx.setFillColor(CustomColors.mainRed.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
        
        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    
}

import Foundation
import UIKit

class Observer<T> {
    typealias Listener = (T) -> ()
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    private var observerBlock: ((T?) -> Void)?
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}

struct ParkingSpace {
    let fromDate: String?
    let isAvailable: Bool?
    let number: String?
    let toDate: String?
}

struct ParkingModel: Codable, Equatable {
//    let name: String?
    let address: String?
//    let capacity: Int?
//    let price: Int?
    let lat: String?
    let lon: String?
}
