//
//  ParkingVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

class ConfirmOrderVC: UIViewController {

    let titleLabel = UILabel()
    
    
    let carModelLabel = UILabel()
    let carNumberLabel = UILabel()
    let carColorLabel = UILabel()
    let carBrandLabel = UILabel()
    let carYearLabel = UILabel()
    
    let carModelTitleLabel = UILabel()
    let carNumberTitleLabel = UILabel()
    let carColorTitleLabel = UILabel()
    let carBrandTitleLabel = UILabel()
    let carYearTitleLabel = UILabel()
    
    lazy var modelStackView = UIStackView(arrangedSubviews: [carModelTitleLabel, carModelLabel])
    lazy var numberStackView = UIStackView(arrangedSubviews: [carNumberTitleLabel, carNumberLabel])
    lazy var colorStackView = UIStackView(arrangedSubviews: [carColorTitleLabel, carColorLabel])
    lazy var brandStackView = UIStackView(arrangedSubviews: [carBrandTitleLabel, carBrandLabel])
    lazy var yearStackView = UIStackView(arrangedSubviews: [carYearTitleLabel, carYearLabel])
    
    let carView = UIView()
    
    lazy var carMainStackView = UIStackView(arrangedSubviews: [modelStackView, numberStackView, colorStackView, brandStackView, yearStackView])
    
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
    let continueButton = CustomButton(title: "Продолжить")
    
    let paymentLabel = UILabel()
    let viewModel = ConfirmOrderViewModel()
    let paymentMethodView = PaymentMethodsView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModel()
        setupUI()
    }
    
    func callToViewModel() {
        viewModel.getCarInfo()
        
        viewModel.cards.bind { [weak self] cards in
            guard let self else { return }
            self.paymentMethodView.paymentMethodsArray = cards
            self.paymentMethodView.collectionView.reloadData()
        }
        
        viewModel.car.bind { [weak self] car in
            guard let self else { return }
            guard let car else { return }
            self.carYearLabel.text = car.year
            self.carBrandLabel.text = car.brand
            self.carColorLabel.text = car.color
            self.carNumberLabel.text = car.number
            self.carModelLabel.text = car.model
        }
    }
    
    @objc func didTapContinue(_ sender: UIButton) {
        let vc = PaymentPageVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConfirmOrderVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        nameView.addSubview(nameLabel)
        [titleLabel, carView, mainView, paymentLabel, paymentMethodView, continueButton].forEach { v in
            view.addSubview(v)
        }
        carView.addSubview(carMainStackView)
        [mainStackView].forEach { l in
            mainView.addSubview(l)
        }
        addActionsForUIElements()
        configureViews()
        setupConstraints()
    }
    
    func addActionsForUIElements() {
        paymentMethodView.delegate = self
        continueButton.addTarget(self, action: #selector(didTapContinue(_:)), for: .touchUpInside)
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
        
        carYearTitleLabel.text = "Год"
        carBrandTitleLabel.text = "Марка машины"
        carModelTitleLabel.text = "Модель машины"
        carColorTitleLabel.text = "Цвет машины"
        carNumberTitleLabel.text = "Номер машины"
        
        
        
        [carView, mainView].forEach { v in
            v.layer.cornerRadius = 14
            v.layer.borderColor = UIColor.systemBlue.cgColor
            v.layer.borderWidth = 1
        }
        
        [nameTitleLabel, timeTitleLabel, parkingTitleLabel, carModelTitleLabel, carNumberTitleLabel, carColorTitleLabel, carBrandTitleLabel, carYearTitleLabel].forEach { l in
            l.textColor = .black
            l.textAlignment = .left
        }
        
        [nameLabel, timeLabel, parkingLabel, carModelLabel, carNumberLabel, carColorLabel, carBrandLabel, carYearLabel].forEach { l in
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
        
        carMainStackView.axis = .vertical
        carMainStackView.spacing = 12
    }
    
    func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        carView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(carView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        carMainStackView.snp.makeConstraints { make in
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
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(48)
        }
    }
}
extension ConfirmOrderVC: PaymentMethodsViewDelegate {
    func didSelect(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
           print("")
        default:
            let vc = AddCardAlertVC(height: 450)
            vc.cardInputDelegate = self
            vc.didDismiss = { [weak self] in
                guard let self else { return }
                let model = BankCardModel(id: 20202020, number: OrderItems.cardNumber, dateExp: "", type: 0, isDefault: true)
                let vm = PaymentMethodDataViewModel(data: model, type: .paybox)
                self.viewModel.cards.value.append(vm)
                self.paymentMethodView.collectionView.reloadData()
            }
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
}

extension ConfirmOrderVC: CardInputViewDelegate {
    func getCardNumber(text: String?) {
        OrderItems.cardNumber = text ?? ""
    }
    
    func getExperationDate(text: String?) {
        
    }
    
    func getCardHolderName(text: String?) {
        
    }
}
