//
//  ViewController.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 05.06.2023.
//

import UIKit

final class LoginVC: UIViewController {
    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewModelOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let emailInputView = BaseInputView()
    let passwordInputView = BaseInputView()
    let mainButton = CustomButton(title: "Войти")
    let registrButton = CustomSecondaryButton(title: "Регистрация")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func emailTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.email = sender.text ?? ""
    }
    
    @objc private func passwordTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.password = sender.text ?? ""
    }
    
    @objc private func showRegistration() {
        let vc = RegistrationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleLogin() {
        viewModel.handleLogin()
    }
}

extension LoginVC: LoginViewModelOutput {
    func loginSuccess() {
        let scene = UIApplication.shared.connectedScenes.first
        if let scene {
            if let sd: SceneDelegate = (scene.delegate as? SceneDelegate) {
                sd.setupAppScreen(scene: scene)
            }
        }
    }
    
    func loginFailure(error: String) {
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
}

extension LoginVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        [titleLabel, emailInputView, passwordInputView, mainButton, registrButton].forEach { subview in
            view.addSubview(subview)
        }
        setupConstraints()
        addActionsForUIElements()
    }
    
    func addActionsForUIElements() {
        registrButton.addTarget(
            self, action: #selector(showRegistration),
            for: .touchUpInside)
        emailInputView.textField.addTarget(
            self, action: #selector(emailTextFieldEditingChanged),
            for: .editingChanged)
        passwordInputView.textField.addTarget(
            self, action: #selector(passwordTextFieldEditingChanged),
            for: .editingChanged)
        mainButton.addTarget(
            self, action: #selector(handleLogin),
            for: .touchUpInside)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        titleLabel.text = "Добро пожаловать!"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        emailInputView.titleLabel.text = "Email"
        emailInputView.textField.newPlaceholder = "Email"
        passwordInputView.titleLabel.text = "Пароль"
        passwordInputView.textField.newPlaceholder = "Пароль"
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
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
        
        registrButton.snp.makeConstraints { make in
            make.top.equalTo(mainButton.snp.bottom).inset(-12)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(48)
        }
    }
}
