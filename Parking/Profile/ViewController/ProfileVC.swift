//
//  ProfileVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 06.06.2023.
//

import UIKit

final class ProfileVC: UIViewController {
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewModelOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let settingsButton = CustomButton(title: "Настройки профиля")
    let carDetailButton = CustomButton(title: "Данные машины")
    let mainButton = CustomButton(title: "Выйти")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc private func handleLogout() {
        viewModel.logOut()
    }
    
    @objc private func handleOpenSettings() {
        let vc = ProfileSettingsVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleOpenCarDetail() {
        let vc = CarDetailVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileVC: ProfileViewModelOutput {
    func logOutSuccess() {
        let scene = UIApplication.shared.connectedScenes.first
        if let scene {
            if let sd: SceneDelegate = (scene.delegate as? SceneDelegate) {
                sd.setupAppScreen(scene: scene)
            }
        }
    }
    
    func logOutFailure(error: String) {
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
}

extension ProfileVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        view.addSubview(titleLabel)
        view.addSubview(settingsButton)
        view.addSubview(mainButton)
        view.addSubview(carDetailButton)
        setupConstraints()
        addActionsForUIElements()
    }
    
    func configureViews() {
        view.backgroundColor = .white
        titleLabel.text = "Профиль"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(48)
        }
        
        carDetailButton.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(48)
        }
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(carDetailButton.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(48)
        }
    }
    
    func addActionsForUIElements() {
        mainButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(handleOpenSettings), for: .touchUpInside)
        carDetailButton.addTarget(self, action: #selector(handleOpenCarDetail), for: .touchUpInside)
    }
}

