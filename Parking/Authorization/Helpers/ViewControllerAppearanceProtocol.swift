//
//  ViewControllerAppearanceProtocol.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 06.06.2023.
//

import Foundation

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
