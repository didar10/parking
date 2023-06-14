//
//  CarDetailVC.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import UIKit

enum CarDetailPageType {
    case fromProfile
    case fromOrder
}

final class CarDetailVC: BaseVC {
    private let viewModel: CarDetailViewModel
    var pageType: CarDetailPageType
    
    init(viewModel: CarDetailViewModel = CarDetailViewModel(),
         pageType: CarDetailPageType) {
        self.viewModel = viewModel
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewModelOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callToViewModel()
    }
    
    private func callToViewModel() {
        viewModel.getCarDetail()
        viewModel.bindCarDetail = {
            self.tableView.reloadData()
        }
    }
    
    @objc private func numberTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.number = sender.text ?? ""
    }
    
    @objc private func colorTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.color = sender.text ?? ""
    }
    
    @objc private func brandTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.brand = sender.text ?? ""
    }
    
    @objc private func modelTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.model = sender.text ?? ""
    }
    
    @objc private func yearTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.year = sender.text ?? ""
    }
    
    @objc private func handleSaveCarDetail() {
        showLoadingIndicator()
        viewModel.saveCarDetail()
    }
}

extension CarDetailVC: CarDetailViewModelOutput {
    func saveCarDetailSuccess() {
        hideLoadingIndicator()
        switch pageType {
        case .fromOrder:
            let vc = ConfirmOrderVC()
            vc.modalPresentationStyle = .overFullScreen
            navigationController?.pushViewController(vc, animated: true)
        case .fromProfile:
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveCarDetailFailure(error: String) {
        hideLoadingIndicator()
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
}

extension CarDetailVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        view.addSubview(tableView)
        setupConstraints()
        registerTableViewCells()
        setupTableView()
    }
    
    func registerTableViewCells() {
        tableView.register(CarDetailCell.self, forCellReuseIdentifier: CarDetailCell.description())
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureViews() {
        view.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension CarDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailCell.description(), for: indexPath) as! CarDetailCell
        if let carDetail = viewModel.carDetail {
            cell.generateCell(carDetail)
        }
        cell.numberInputView.textField.addTarget(
            self, action: #selector(numberTextFieldEditingChanged),
            for: .editingChanged)
        cell.colorInputView.textField.addTarget(
            self, action: #selector(colorTextFieldEditingChanged),
            for: .editingChanged)
        cell.yearInputView.textField.addTarget(
            self, action: #selector(yearTextFieldEditingChanged),
            for: .editingChanged)
        cell.brandInputView.textField.addTarget(
            self, action: #selector(brandTextFieldEditingChanged),
            for: .editingChanged)
        cell.modelInputView.textField.addTarget(
            self, action: #selector(modelTextFieldEditingChanged),
            for: .editingChanged)
        cell.mainButton.addTarget(
            self, action: #selector(handleSaveCarDetail),
            for: .touchUpInside)
        return cell
    }
}

extension CarDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
