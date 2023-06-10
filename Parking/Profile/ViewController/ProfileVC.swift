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
    
    let mainButton = CustomButton(title: "Войти")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc private func handleLogout() {
        viewModel.logOut()
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
        view.addSubview(mainButton)
        setupConstraints()
        addActionsForUIElements()
    }
    
    func configureViews() {
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(48)
        }
    }
    
    func addActionsForUIElements() {
        mainButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
}

