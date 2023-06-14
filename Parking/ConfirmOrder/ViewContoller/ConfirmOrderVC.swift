//
//  ParkingVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

class ConfirmOrderVC: UIViewController {

    let titleLabel = UILabel()
    
    let nameLabel = UILabel()
    let nameTitleLabel = UILabel()
    let nameView = UIView()
    lazy var nameStackView = UIStackView(arrangedSubviews: [nameTitleLabel, nameView])
    let timeTitleLabel = UILabel()
    let timeLabel = UILabel()
    lazy var timeStackView = UIStackView(arrangedSubviews: [timeTitleLabel, timeLabel])
    let parkingTitleLabel = UILabel()
    let parkingLabel = UILabel()
    lazy var parkingStackView = UIStackView(arrangedSubviews: [parkingTitleLabel, parkingLabel])
    lazy var mainStackView = UIStackView(arrangedSubviews: [nameStackView, parkingStackView, timeStackView])
    let mainView = UIView()
    
    let paymentLabel = UILabel()
    let paymentMethodView = PaymentMethodsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension ConfirmOrderVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        nameView.addSubview(nameLabel)
        [titleLabel, mainView, paymentLabel, paymentMethodView].forEach { v in
            view.addSubview(v)
        }
        [mainStackView].forEach { l in
            mainView.addSubview(l)
        }
        addActionsForUIElements()
        configureViews()
        setupConstraints()
    }
    
    func addActionsForUIElements() {
        paymentMethodView.delegate = self
    }
    
    func configureViews() {
        view.backgroundColor = .white
        [titleLabel].forEach { l in
            l.textColor = .black
        }
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "Подтверждение"
        
        nameTitleLabel.text = "Название"
        nameLabel.numberOfLines = 0
        timeTitleLabel.text = "Время"
        parkingTitleLabel.text = "Место"
        
        nameLabel.text = OrderItems.name
        timeLabel.text = OrderItems.time
        parkingLabel.text = OrderItems.space
        
        mainView.layer.cornerRadius = 14
        mainView.layer.borderColor = UIColor.systemBlue.cgColor
        mainView.layer.borderWidth = 1
        
        [nameTitleLabel, timeTitleLabel, parkingTitleLabel].forEach { l in
            l.textColor = .black
            l.textAlignment = .left
        }
        
        [nameLabel, timeLabel, parkingLabel].forEach { l in
            l.textColor = .systemBlue
            l.textAlignment = .right
        }
        
        [nameTitleLabel, nameLabel, timeTitleLabel, timeLabel, parkingTitleLabel, parkingLabel].forEach { l in
            l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        [nameStackView, timeStackView, parkingStackView].forEach { stack in
            stack.axis = .horizontal
            
        }
        
        paymentLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        paymentLabel.textColor = .black
        paymentLabel.text = "Способ оплаты"
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
    }
    
    func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        paymentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        paymentMethodView.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(paymentLabel.snp.bottom).offset(12)
//            make.bottom.equalToSuperview().inset(12)
        }
    }
}
extension ConfirmOrderVC: PaymentMethodsViewDelegate {
    func didSelect(at indexPath: IndexPath) {
        
    }
}
