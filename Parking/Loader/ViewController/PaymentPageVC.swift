//
//  PaymentPageVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

final class PaymentPageVC: UIViewController {
    //MARK: - Properties
    let loadingView = PaymentLoadingView()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar(isHidden: true)
        navigationBarSwipeGesture(isEnabled: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarSwipeGesture(isEnabled: true)
    }
}

//MARK: - ViewControllerAppearanceProtocol
extension PaymentPageVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        view.addSubview(loadingView)
        setupConstraints()
    }
    
    func configureViews() {
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
