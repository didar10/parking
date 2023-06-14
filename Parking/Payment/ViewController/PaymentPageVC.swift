//
//  PaymentPageVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

final class PaymentPageVC: UIViewController {
    private let viewModel: PaymentPageViewModel
    
    init(viewModel: PaymentPageViewModel = PaymentPageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewModelOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let loadingView = PaymentLoadingView()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar(isHidden: true)
        navigationBarSwipeGesture(isEnabled: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBar(isHidden: false)
        navigationBarSwipeGesture(isEnabled: true)
    }
    
    private func callToViewModel() {
        viewModel.saveParking()
    }
}

extension PaymentPageVC: PaymentPageViewModelOutput {
    func saveParkingHistorySuccess() {
        StaticItems.saveDataSuccessCallBack()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func saveParkingHistoryFailure() {
        navigationController?.popToRootViewController(animated: true)
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
