//
//  ViewController.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 05.06.2023.
//

import UIKit

final class LoginVC: UIViewController {
    let titleLabel = UILabel()
    let emailInputView = BaseInputView()
    let passwordInputView = BaseInputView()
    let mainButton = CustomButton(title: "Войти")
    let registrButton = CustomSecondaryButton(title: "Регистрация")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension LoginVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        [titleLabel, emailInputView, passwordInputView, mainButton, registrButton].forEach { subview in
            view.addSubview(subview)
        }
        setupConstraints()
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
