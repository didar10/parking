//
//  PaymentMethodsView.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

protocol PaymentMethodsViewDelegate: AnyObject {
    func didSelect(at indexPath: IndexPath)
}

final class PaymentMethodsView: UIView {
    var paymentMethodsArray: [PaymentMethodDataViewModel]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: layout)
    weak var delegate: PaymentMethodsViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configureViews()
        setupViews()
        registerCollectionViewCells()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(
            PaymentMethodCVCell.self,
            forCellWithReuseIdentifier: PaymentMethodCVCell.description())
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PaymentMethodsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(at: indexPath)
    }
}

extension PaymentMethodsView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch indexPath.section {
            case 0:
                let font = UIFont.systemFont(ofSize: 13, weight: .medium)
                let fontAttributes = [NSAttributedString.Key.font: font]
                if let title = paymentMethodsArray?[indexPath.item].title {
                    let size = (title as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                    return CGSize(width: size.width + 60, height: 38)
                }
                return CGSize(width: 0, height: 0)
            default:
                let font =  UIFont.systemFont(ofSize: 13, weight: .medium)
                let fontAttributes = [NSAttributedString.Key.font: font]
                let size = ("Добавить" as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                return CGSize(width: size.width + 60, height: 38)
            }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            switch section {
            case 0:
                return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            default:
                return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16)
            }
    }
}

//MARK: - UICollectionViewDataSource
extension PaymentMethodsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return paymentMethodsArray?.count ?? 0
        default:
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodCVCell.description(),
            for: indexPath) as! PaymentMethodCVCell
            switch indexPath.section {
            case 0:
                if let data = paymentMethodsArray?[indexPath.item] {
                    cell.generateCell(data)
                }
            default:
                cell.titleLabel.text = "Добавить"
//                cell.iconImageView.image = ImageConstants.plusButton
            }
        return cell
    }
}

final class BaseCardView: UIView {
    init(isHaveShadow: Bool = false) {
        super.init(frame: .zero)
        layer.borderWidth = 1
        layer.cornerRadius = 14
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSelect() {
        layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func didUnSelect() {
        layer.borderColor = UIColor.systemGray.cgColor
    }
}
