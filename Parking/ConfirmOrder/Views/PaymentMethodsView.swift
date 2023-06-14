//
//  PaymentMethodsView.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

protocol PaymentMethodsViewDelegate: AnyObject {
    func didSelect(at indexPath: IndexPath)
}

final class PaymentMethodsView: UIView {
    var paymentMethodsArray: [PaymentMethodDataViewModel]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: layout)
    weak var delegate: PaymentMethodsViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configureViews()
        setupViews()
        registerCollectionViewCells()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(
            PaymentMethodCVCell.self,
            forCellWithReuseIdentifier: PaymentMethodCVCell.description())
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PaymentMethodsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(at: indexPath)
    }
}

extension PaymentMethodsView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch indexPath.section {
            case 0:
                let font = UIFont.systemFont(ofSize: 13, weight: .medium)
                let fontAttributes = [NSAttributedString.Key.font: font]
                if let title = paymentMethodsArray?[indexPath.item].title {
                    let size = (title as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                    return CGSize(width: size.width + 60, height: 38)
                }
                return CGSize(width: 0, height: 0)
            default:
                let font =  UIFont.systemFont(ofSize: 13, weight: .medium)
                let fontAttributes = [NSAttributedString.Key.font: font]
                let size = ("Добавить" as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                return CGSize(width: size.width + 60, height: 38)
            }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            switch section {
            case 0:
                return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            default:
                return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16)
            }
    }
}

//MARK: - UICollectionViewDataSource
extension PaymentMethodsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return paymentMethodsArray?.count ?? 0
        default:
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodCVCell.description(),
            for: indexPath) as! PaymentMethodCVCell
            switch indexPath.section {
            case 0:
                if let data = paymentMethodsArray?[indexPath.item] {
                    cell.generateCell(data)
                }
            default:
                cell.titleLabel.text = "Добавить"
//                cell.iconImageView.image = ImageConstants.plusButton
            }
        return cell
    }
}

final class BaseCardView: UIView {
    init(isHaveShadow: Bool = false) {
        super.init(frame: .zero)
        layer.borderWidth = 1
        layer.cornerRadius = 14
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSelect() {
        layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func didUnSelect() {
        layer.borderColor = UIColor.systemGray.cgColor
    }
}

final class AddCardAlertVC: UIViewController, DismissViewControllerProtocol {
    let backgroundView = UIView()
    var customView = UIView()
    var height: CGFloat
    private let cardView = CardInputView()
    
    weak var cardInputDelegate: CardInputViewDelegate?
    
    let continueButton = CustomButton(title: "Продолжить")
    var didDismiss: (() -> ())?

    init(height: CGFloat) {
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func didTapContinueButton(_ sender: UIButton) {
        self.dismissByFade()
        didDismiss?()
    }
}

extension AddCardAlertVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(customView)
        customView.addSubview(cardView)
        customView.addSubview(continueButton)
        configureViews()
        setupDelegates()
        setupConstraints()
        addActionsForUIElements()
    }
    
    func configureViews() {
  
        view.backgroundColor = .clear
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.6
        customView.backgroundColor = .white
        customView.layer.cornerRadius = 14
    }
    
    func setupDelegates() {
        [cardView.numberTextField,
         cardView.expirationTextField,
         cardView.codeTextField].forEach { t in
            t.delegate = self
        }
    }
    
    func addActionsForUIElements() {
        if backgroundView.isUserInteractionEnabled {
            backgroundView.onTapped { [unowned self] in
                dismissByFade()
            }
        }
        continueButton.addTarget(self, action: #selector(didTapContinueButton(_:)), for: .touchUpInside)
    }
    
    func dismissViewController(completion: @escaping () -> ()) {
        dismissByFade()
        completion()
    }

    
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        customView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
extension AddCardAlertVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardView.numberTextField {
            guard let text = textField.text else { return false }
            let beginning = textField.beginningOfDocument
            // save cursor location
            let cursorLocation = textField.position(from: beginning, offset: range.location + string.count)
            
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "XXXX XXXX XXXX XXXX")
            self.cardInputDelegate?.getCardNumber(text: newString)
            if let cL = cursorLocation {
                let textRange = textField.textRange(from: cL, to: cL) //textRangeFromPosition(cL, toPosition: cL)
                textField.selectedTextRange = textRange
            }
            
            if let text = textField.text {
                if text.count == 19 {
                    cardView.expirationTextField.becomeFirstResponder()
                }
            }
            return false
        } else if textField == cardView.expirationTextField {
            guard let text = textField.text else { return false }
            let beginning = textField.beginningOfDocument
            // save cursor location
            let cursorLocation = textField.position(from: beginning, offset: range.location + string.count)
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "XX/XX")
            
            if let cL = cursorLocation {
                let textRange = textField.textRange(from: cL, to: cL) //textRangeFromPosition(cL, toPosition: cL)
                textField.selectedTextRange = textRange
            }
            
            if let text = textField.text {
                if text.count == 5 {
                    cardView.codeTextField.becomeFirstResponder()
                }
            }
            return false
        } else  {
            guard let text = textField.text else { return false }
            let beginning = textField.beginningOfDocument
            // save cursor location
            let cursorLocation = textField.position(from: beginning, offset: range.location + string.count)
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "XXX")
            
            if let cL = cursorLocation {
                let textRange = textField.textRange(from: cL, to: cL)
                textField.selectedTextRange = textRange
            }
            
            if let text = textField.text {
                if text.count == 3 {
                    cardView.nameTextField.becomeFirstResponder()
                }
            }
            return false
        }
    }
}

//MARK: - CardInputViewDelegate
extension AddCardAlertVC: CardInputViewDelegate {
    func getCardNumber(text: String?) {
        OrderItems.cardNumber = text ?? ""
        cardView.numberTextField.text = text
    }

    func getExperationDate(text: String?) {
        cardView.expirationTextField.text = text
    }
    
    func getCardHolderName(text: String?) {
        cardView.nameTextField.text = text
    }
}
