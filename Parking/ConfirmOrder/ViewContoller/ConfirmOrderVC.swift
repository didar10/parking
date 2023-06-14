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


final class ConfirmOrderViewModel: NSObject {
    var dataManager: DataManager
    
    var car: Observer<CarDetail?> = Observer(value: nil)
    
    var cards: Observer<[PaymentMethodDataViewModel]> = Observer(value: [])
    
    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
    
    func getCarInfo() {
        dataManager.getCarDetail { [weak self] detail in
            guard let self else { return }
            print("detail \(detail)")
            self.car.value = detail
        }
    }
}


protocol CardInputViewDelegate: AnyObject {
    func getCardNumber(text: String?)
    func getExperationDate(text: String?)
    func getCardHolderName(text: String?)
}

final class CardInputView: BaseUIView {
    let cardTitleLabel = UILabel()
    let cardIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 36))
    
    let numberCardView = UIView()
    let numberLabel = UILabel()
    let numberTextField = CustomTextField(padding: 0)
    let scanButton = UIButton(type: .system)
    lazy var numberStackView = UIStackView(arrangedSubviews: [numberLabel, numberTextField])
    
    let expirationCardView = UIView()
    let expirationLabel = UILabel()
    let expirationTextField = CustomTextField(padding: 0)
    lazy var expirationStackView = UIStackView(arrangedSubviews: [expirationLabel, expirationTextField])
    
    let codeCardView = UIView()
    let codeLabel = UILabel()
    let codeTextField = CustomTextField(padding: 0)
    lazy var codeStackView = UIStackView(arrangedSubviews: [codeLabel, codeTextField])
    
    lazy var cardStackView = UIStackView(arrangedSubviews: [expirationCardView, codeCardView])
    
    let nameCardView = UIView()
    let nameLabel = UILabel()
    let nameTextField = CustomTextField(padding: 0)
    lazy var nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])

    override func setupViews() {
        super.setupViews()
        [cardTitleLabel, numberCardView, cardStackView, nameCardView].forEach { v in
            addSubview(v)
        }
        
        [numberStackView, scanButton].forEach { v in
            numberCardView.addSubview(v)
        }
        
        expirationCardView.addSubview(expirationStackView)
        codeCardView.addSubview(codeStackView)
        nameCardView.addSubview(nameStackView)
    }
    
    override func configureViews() {
        super.configureViews()
        layer.cornerRadius = 14
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
        
        cardTitleLabel.textColor = .black
        cardTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cardTitleLabel.text = "DEBIT / CREDIT"
        
        [numberCardView, codeCardView, expirationCardView, nameCardView].forEach { v in
            v.layer.cornerRadius = 14
            v.layer.borderColor = UIColor.systemBlue.cgColor
            v.layer.borderWidth = 1
        }
        
        [numberLabel, expirationLabel, codeLabel, nameLabel].forEach { l in
            l.textColor = .black
            l.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        }
        
        numberLabel.text = "Номер Карты"
        expirationLabel.text = "Срок Действия"
        codeLabel.text = "Код безапасности"
        nameLabel.text = "Имя на карте"
        
        [numberTextField, expirationTextField, codeTextField].forEach { t in
            t.keyboardType = .numberPad
        }
        
        nameTextField.autocapitalizationType = .allCharacters
        
        numberTextField.newPlaceholder = "0000 0000 0000 0000"
        expirationTextField.newPlaceholder = "MM/YY"
        codeTextField.newPlaceholder = "000"
        nameTextField.newPlaceholder = "Имя на карте"
        
        [numberStackView, expirationStackView, codeStackView, nameStackView].forEach { s in
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.spacing = 8
        }
        
        cardStackView.axis = .horizontal
        cardStackView.distribution = .fillEqually
        cardStackView.spacing = 12
        
        cardIconImageView.contentMode = .scaleAspectFill
    }
    
    func changeCardHeader() {
        cardTitleLabel.removeFromSuperview()
        cardTitleLabel.text = nil
        addSubview(cardIconImageView)
        cardIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(36)
            make.width.equalTo(40)
        }
        
        numberCardView.snp.remakeConstraints { make in
            make.top.equalTo(cardIconImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        [numberTextField, expirationTextField, codeTextField, nameTextField].forEach { v in
            v.snp.remakeConstraints { make in
                make.height.equalTo(20)
            }
        }
        
        numberStackView.snp.remakeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(50)
        }
        
        scanButton.snp.remakeConstraints { make in
            make.centerY.equalTo(numberStackView)
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(32)
        }
        
        cardStackView.snp.remakeConstraints { make in
            make.top.equalTo(numberCardView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        nameCardView.snp.remakeConstraints { make in
            make.top.equalTo(cardStackView.snp.bottom).inset(-12)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        nameStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        expirationStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        codeStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(12)
        }
        
        numberCardView.snp.makeConstraints { make in
            make.top.equalTo(cardTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        [numberTextField, expirationTextField, codeTextField, nameTextField].forEach { v in
            v.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
        
        numberStackView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(50)
        }
        
        scanButton.snp.makeConstraints { make in
            make.centerY.equalTo(numberStackView)
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(32)
        }
        
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(numberCardView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        nameCardView.snp.makeConstraints { make in
            make.top.equalTo(cardStackView.snp.bottom).inset(-12)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        expirationStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        codeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
}




