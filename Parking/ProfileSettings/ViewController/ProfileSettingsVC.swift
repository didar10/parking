//
//  ProfileSettingsVC.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 10.06.2023.
//

import UIKit

final class ProfileSettingsVC: UIViewController {
    private let viewModel: ProfileSettingsViewModel
    
    init(viewModel: ProfileSettingsViewModel = ProfileSettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let titleLabel = UILabel()
    let fioInputView = BaseInputView()
    let phoneInputView = BaseInputView()
    let emailInputView = BaseInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callToViewModel()
    }
    
    private func callToViewModel() {
        viewModel.getProfile()
        viewModel.bindProfile = {
            if let profile = self.viewModel.profile {
                self.fioInputView.textField.text = profile.name
                self.emailInputView.textField.text = profile.email
                self.phoneInputView.textField.text = profile.phone
            }
        }
    }
}

extension ProfileSettingsVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        [titleLabel, emailInputView, fioInputView, phoneInputView].forEach { subview in
            view.addSubview(subview)
        }
        setupConstraints()
    }
    
    func configureViews() {
        view.backgroundColor = .white
        titleLabel.text = "Настройки профиля"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        fioInputView.titleLabel.text = "ФИО"
        fioInputView.textField.newPlaceholder = "ФИО"
        phoneInputView.titleLabel.text = "Телефон"
        phoneInputView.textField.newPlaceholder = "Телефон"
        emailInputView.titleLabel.text = "Email"
        emailInputView.textField.newPlaceholder = "Email"
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        fioInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneInputView.snp.makeConstraints { make in
            make.top.equalTo(fioInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(phoneInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
