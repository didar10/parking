//
//  PlacesVC.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import UIKit

final class PlacesVC: UIViewController {
    let titleLabel = UILabel()
    lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    var busSeatNumDict = [Int : String]()
    var viewModel = PlacesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        setData()
        callToViewModel()
    }
    
    func setData() {
        for i in 0...59
        {
            busSeatNumDict[i] = String(i)
        }
    }
    
    
    func callToViewModel() {
        viewModel.getCarInfo()
        viewModel.setUpPlaces()
        viewModel.placesArray.bind { [weak self] value in
            guard let self else { return }
            guard let value else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
//        viewModel.car.bind { [weak self] car in
//            guard let self else { return }
//            guard let value else { return }
//        }
    }
}

extension PlacesVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        setupConstraints()
        registerCollectionViewCells()
        setupCollectionView()
    }
    
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .black
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func registerCollectionViewCells() {
        collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: PlaceCell.description())
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PlacesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let arr = viewModel.placesArray.value {
            if arr[indexPath.item].isAvailable ?? false {
                let vc = TimeAlertVC(height: 300)
                vc.modalPresentationStyle = .overFullScreen
                vc.fromTextField.timeTextField.changeDateCallBack = { [weak self] date in
                    guard let self else { return }
                    print("<================ DATE time 1 \(date)")
                    let time = date.getFormattedData(getDateFormat: "HH:mm")
                    print("<================ DATE time 2 \(time)")
                    self.viewModel.passFromTime(time: time)
                }
                vc.toTextField.timeTextField.changeDateCallBack = { [weak self] date in
                    guard let self else { return }
                    print("<================ DATE time 1 \(date)")
                    let time = date.getFormattedData(getDateFormat: "HH:mm")
                    print("<================ DATE time 2 \(time)")
                    self.viewModel.passToTime(time: time)
                }
                vc.didDismiss = { [weak self] in
                    guard let self else { return }
                    OrderItems.fromTime = self.viewModel.fromTime
                    OrderItems.toTime = self.viewModel.toTime
                    OrderItems.time = self.viewModel.fromTime + " - " + self.viewModel.toTime
                    OrderItems.space = arr[indexPath.item].number ?? ""
                    OrderItems.name = self.titleLabel.text ?? ""
                    if !self.viewModel.fromTime.isEmpty && !self.viewModel.fromTime.isEmpty {
                        if let _ = self.viewModel.car.value {
                            let vc = ConfirmOrderVC()
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = CarDetailVC(pageType: .fromOrder)
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                present(vc, animated: true)
            } else {
                if let fromDate = arr[indexPath.item].fromDate, let toDate = arr[indexPath.item].toDate {
                    setAlertView(text: "занято с \(fromDate) по \(toDate)", time: 1.5)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: ((self.collectionView.frame.width) / 4) - 20, height: (self.collectionView.frame.width) / 4)
    }
}

extension PlacesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  PlaceCell.description(), for: indexPath) as! PlaceCell
        if let arr = viewModel.placesArray.value {
            cell.generateCells(arr[indexPath.item])
        }
      
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = viewModel.placesArray.value {
            return arr.count
        }
        return 0
    }
}
