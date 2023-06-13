//
//  PlacesVC.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import UIKit

final class PlacesVC: UIViewController {
    lazy var layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    var busSeatNumDict = [Int : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }
    
    func setData() {
        for i in 0...59
        {
            busSeatNumDict[i] = String(i)
        }
    }
}

extension PlacesVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        view.addSubview(collectionView)
        setupConstraints()
        registerCollectionViewCells()
        setupCollectionView()
    }
    
    func configureViews() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: ((self.collectionView.frame.width) / 4) - 20, height: (self.collectionView.frame.width) / 4)
    }
}

extension PlacesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  PlaceCell.description(), for: indexPath) as! PlaceCell
//        cell.alpha = 0 // Initially alpha 0
        let text = busSeatNumDict[indexPath.row]!

//        if text == "" || text == "2"
//        {
//            cell.alpha = 0
//        }
//        else
//        {
//            cell.alpha = 1
//        }
//        cell.backgroundColor = UIColor.clear

        cell.seatNumberLabel.text = text
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 60
    }
}
