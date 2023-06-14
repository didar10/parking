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

protocol ConfigureCellUI {
    func configureViews()
    func setupConstraints()
    func setupTableView()
    func registerTableViewCells()
    func registerCollectionViewCells()
    func setupCollectionView()
    func addActionsForUIElements()
}

extension ConfigureCellUI {
    func configureViews() {}
    func setupConstraints() {}
    func setupTableView() {}
    func registerTableViewCells() {}
    func registerCollectionViewCells() {}
    func setupCollectionView() {}
    func addActionsForUIElements() {}
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

extension UIViewController {
    func setAlertView(text: String, time: Double) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + time
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismissByFade(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        if let window = view.window {
            window.layer.backgroundColor = UIColor.white.cgColor
            window.layer.add(transition, forKey: kCATransition)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func presentByFade(controller: UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        if let window = view.window {
            window.layer.backgroundColor = UIColor.white.cgColor
            window.layer.add(transition, forKey: kCATransition)
        }
        present(controller, animated: false, completion: nil)
    }
    
}
extension UIView {
    func onTapped(action: (() -> Void)?) {
        tapAction = action
        let selector = #selector(handleTap)
        let recognizer = UITapGestureRecognizer(target: self, action: selector)
        isUserInteractionEnabled = true
        addGestureRecognizer(recognizer)
    }
}

fileprivate extension UIView {
    typealias Action = (() -> Void)
    
    struct Key { static var id = "tapAction" }
    
    var tapAction: Action? {
        get {
            return objc_getAssociatedObject(self, &Key.id) as? Action
        }
        set {
            guard let value = newValue else { return }
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            objc_setAssociatedObject(self, &Key.id, value, policy)
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        tapAction?()
    }
}
struct OrderItems {
    static var space = String()
    static var name = String()
    static var time = String()
    
    static var cardNumber = String()
//    
//    static var number = String()
//    static var color = String()
//    static var brand = String()
//    static var model = String()
//    static var year = String()
}

class BaseUICollectionViewCell: UICollectionViewCell {
    
    lazy var sizeScreen: CGFloat = UIScreen.main.bounds.height
    lazy var height: CGFloat = UIScreen.main.bounds.height
    lazy var width: CGFloat = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .clear
    }
    
    func boxCell() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 54
        }
        
        if (height > 790 && width > 400) {
            return 60
        }
        
        else {
            return 56
        }
    }
    
    func fontMedium() -> Float {
        
        if (height > 740 && width < 400) {
            return 14
        }
        
        if (height > 790 && width > 400) {
            return 16
        }
        
        else {
            return 16
        }
    }
    
    func fontBig() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 20
        }
        
        if (height > 790 && width > 400) {
            return 24
        }
        
        else {
            return 20
        }
    }
    
    func medium() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 44
        }
        
        if (height > 790 && width > 400) {
            return 52
        }
        
        else {
            return 48
        }
    }
    
    func big() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 48
        }
        
        if (height > 790 && width > 400) {
            return 60
        }
        
        else {
            return 52
        }
    }
    
    func box() -> CGFloat {
        
        if (height > 740 && width < 400) {
            return 48
        }
        
        if (height > 790 && width > 400) {
            return 60
        }
        
        else {
            return 52
        }
    }
}
extension UIViewController {
    func navigationBar(isHidden: Bool){
        navigationController?.navigationBar.isHidden = isHidden
    }
    
    func navigationBarSwipeGesture(isEnabled: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
}
