//
//  AddCardAlertVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

final class AddCardAlertVC: UIViewController, DismissViewControllerProtocol {
    let backgroundView = UIView()
    var customView = UIView()
    var height: CGFloat
    private let cardView = CardInputView()
    
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
        cardView.numberTextField.text = text
    }

    func getExperationDate(text: String?) {
        cardView.expirationTextField.text = text
    }
    
    func getCardHolderName(text: String?) {
        cardView.nameTextField.text = text
    }
}
