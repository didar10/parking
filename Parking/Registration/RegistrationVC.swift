//
//  RegistrationVC.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 07.06.2023.
//

import UIKit

final class RegistrationVC: BaseVC {
    var viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel = RegistrationViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewModelOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let fioInputView = BaseInputView()
    let phoneInputView = BaseInputView()
    let emailInputView = BaseInputView()
    let passwordInputView = BaseInputView()
    let mainButton = CustomButton(title: "Регистрация")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func fullNameTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.fullName = sender.text ?? ""
    }
    
    @objc private func phoneTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.phone = sender.text ?? ""
    }
    
    @objc private func emailTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.email = sender.text ?? ""
    }
    
    @objc private func passwordTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.password = sender.text ?? ""
    }
    
    @objc private func handleRegistration() {
        showLoadingIndicator()
        viewModel.handleRegistration()
    }
}

extension RegistrationVC: RegistrationViewModelOutput {
    func registrationSuccess() {
        hideLoadingIndicator()
        let scene = UIApplication.shared.connectedScenes.first
        if let scene {
            if let sd: SceneDelegate = (scene.delegate as? SceneDelegate) {
                sd.setupAppScreen(scene: scene)
            }
        }
    }
    
    func registrationFailure(error: String) {
        hideLoadingIndicator()
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
}

extension RegistrationVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        [titleLabel, emailInputView, passwordInputView, mainButton, fioInputView, phoneInputView].forEach { subview in
            view.addSubview(subview)
        }
        setupConstraints()
        addActionsForUIElements()
    }
    
    func addActionsForUIElements() {
        fioInputView.textField.addTarget(
            self, action: #selector(fullNameTextFieldEditingChanged),
            for: .editingChanged)
        phoneInputView.textField.addTarget(
            self, action: #selector(phoneTextFieldEditingChanged),
            for: .editingChanged)
        emailInputView.textField.addTarget(
            self, action: #selector(emailTextFieldEditingChanged),
            for: .editingChanged)
        passwordInputView.textField.addTarget(
            self, action: #selector(passwordTextFieldEditingChanged),
            for: .editingChanged)
        mainButton.addTarget(
            self, action: #selector(handleRegistration),
            for: .touchUpInside)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        titleLabel.text = "Регистрация"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        fioInputView.titleLabel.text = "ФИО"
        fioInputView.textField.newPlaceholder = "ФИО"
        phoneInputView.titleLabel.text = "Телефон"
        phoneInputView.textField.keyboardType = .phonePad
        phoneInputView.textField.newPlaceholder = "Телефон"
        emailInputView.titleLabel.text = "Email"
        emailInputView.textField.newPlaceholder = "Email"
        emailInputView.textField.keyboardType = .emailAddress
        passwordInputView.titleLabel.text = "Пароль"
        passwordInputView.textField.newPlaceholder = "Пароль"
        passwordInputView.textField.isSecureTextEntry = true
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
        
        passwordInputView.snp.makeConstraints { make in
            make.top.equalTo(emailInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInputView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(48)
        }
    }
}

